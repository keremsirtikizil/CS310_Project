import 'package:flutter/material.dart';
import 'package:grocery_list/utils/AppColors.dart';
import 'package:grocery_list/utils/navbar.dart';
import 'package:grocery_list/utils/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_list/routes/shoppingListDetailsScreen.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  double currentTotal = 0.0;
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    loadShoppingLists();
  }

  Future<void> loadShoppingLists() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('shoppingLists')
        .where('userId', isEqualTo: uid)
        .get();

    final loadedItems = snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'] ?? 'Unnamed List',
        'totalPrice': (data['totalPrice'] ?? 0).toDouble(),
        'items': data['items'] ?? [],
      };
    }).toList();

    double total = loadedItems.fold(0, (sum, item) => sum + item['totalPrice']);

    setState(() {
      items = loadedItems;
      currentTotal = total;
    });
  }

  Future<void> markAsPurchased(Map<String, dynamic> item, int index) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Purchase"),
        content: const Text("Are you sure you want to mark this list as bought? This will move all items to your fridge."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final itemsList = item['items'] ?? [];
    for (final product in itemsList) {
      await FirebaseFirestore.instance
          .collection('fridgeItems')
          .doc(uid)
          .collection('items')
          .add({
        ...product,
        'purchasedAt': FieldValue.serverTimestamp(),
      });
    }

    await FirebaseFirestore.instance
        .collection('shoppingLists')
        .doc(item['id'])
        .delete();

    setState(() {
      items.removeAt(index);
      currentTotal = items.fold(0,
          (sum, item) => sum + (item['totalPrice'] as num).toDouble());
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Items moved to fridge!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithArrow(),
      backgroundColor: AppColors.mainBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  await Navigator.pushNamed(context, "/newListCreation");
                  await loadShoppingLists();
                },
                child: const Text(
                  'Create New List',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text("No lists found."))
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.boxColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Total Price: \$${(item['totalPrice'] as num).toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.check_circle, color: Colors.green),
                                  tooltip: "Mark as Bought",
                                  onPressed: () => markAsPurchased(item, index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.visibility),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShoppingListDetailsScreen(
                                          shoppingList: item,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    final docId = item['id'];
                                    await FirebaseFirestore.instance
                                        .collection('shoppingLists')
                                        .doc(docId)
                                        .delete();
                                    setState(() {
                                      items.removeAt(index);
                                      currentTotal = items.fold(
                                        0,
                                        (sum, item) =>
                                            sum + (item['totalPrice'] as num).toDouble(),
                                      );
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Deleted list from server"),
                                        duration: Duration(seconds: 2),
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.boxColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${currentTotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppNavBar(currentIndex: 1),
    );
  }
} 