import 'package:flutter/material.dart';
import 'package:grocery_list/utils/navbar.dart';
import 'package:grocery_list/routes/barcodeScannerScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewListCreation extends StatelessWidget {
  const NewListCreation({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShoppingList();
  }
}

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<ShoppingItem> items = [];

  double get totalPrice {
    return items.fold(0.0, (sum, item) => sum + item.price);
  }

  Future<String?> promptForListName(BuildContext context) async {
    String tempName = "";
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Enter Shopping List Name"),
        content: TextField(
          autofocus: true,
          onChanged: (value) => tempName = value,
          decoration: const InputDecoration(hintText: "e.g. Weekend Groceries"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (tempName.trim().isNotEmpty) {
                Navigator.pop(context, tempName.trim());
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithArrow(),
      body: Column(
        children: [
          /// Header Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                "You're creating a new list.",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          /// Column Titles
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text("Product Name", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Price", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Amount/Weight", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Expiry Date", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 8),

          /// List of items
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Center(
                        child: Text(
                          item.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        )
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "${item.price}\$",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child:Center(
                        child: Text(
                          item.amount,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),),
                      ),
                      Expanded(
                        flex: 3,
                        child: Center(
                        child: Text(
                          item.expiry,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          final deletedItem = items[index];
                          final deletedIndex = index;
                          setState(() {
                            items.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Product: \"${deletedItem.name}\" is deleted.",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.grey.shade400,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              action: SnackBarAction(
                                label: "UNDO",
                                textColor: Colors.black,
                                onPressed: () {
                                  setState(() {
                                    items.insert(deletedIndex, deletedItem);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          /// Total price
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("Current Total: ${totalPrice.toStringAsFixed(2)}\$"),
          ),

          /// Add New Item Button
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/barcode_scan');
              if (result != null && result is ShoppingItem) {
                setState(() {
                  items.add(result);
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 172, 219, 175),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text("Add New Item"),
          ),
          const SizedBox(height: 8),

          /// Save Shopping List Button
          ElevatedButton(
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid == null) return;

              final enteredName = await promptForListName(context);
              if (enteredName == null) return;

              final shoppingData = {
                'userId': uid,
                'name': enteredName,
                'totalPrice': totalPrice,
                'items': items.map((item) => {
                      'name': item.name,
                      'price': item.price,
                      'amount': item.amount,
                      'expiry': item.expiry,
                    }).toList(),
                'createdAt': FieldValue.serverTimestamp(),
              };

              final docRef = await FirebaseFirestore.instance
                  .collection('shoppingLists')
                  .add(shoppingData);

              final savedDoc = await docRef.get();
              Navigator.pop(context, savedDoc.data());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 164, 226, 167),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: const Text("Save The Shopping List"),
          ),
          const SizedBox(height: 12),
        ],
      ),
      bottomNavigationBar: AppNavBar(currentIndex: 1),
    );
  }
}
