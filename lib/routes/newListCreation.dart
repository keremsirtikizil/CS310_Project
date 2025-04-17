import 'package:flutter/material.dart';
import 'package:grocery_list/utils/navbar.dart';
import 'package:grocery_list/routes/barcodeScannerScreen.dart';



class NewListCreation extends StatelessWidget{
  const NewListCreation({super.key});
  @override
  Widget build(BuildContext context) {
      return  const ShoppingList();
  }
}

class ShoppingList extends StatefulWidget{
  const ShoppingList({super.key});
  @override 
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList>{  
  List<ShoppingItem> items = [
    ShoppingItem("Milk", 2.99, "1.5L", "11.04.2025"),
    ShoppingItem("Juice", 6.99, "1.0L", "14.05.2025"),
    ShoppingItem("Tobacco", 22.99, "1", "14.05.2025"),
    ShoppingItem("Apple", 0.79, "250g", "20.03.2025"),
    ShoppingItem("Kerem", 100.09, "1025kg", "11.11.1111"),
    ShoppingItem("Emirhan", 100.09, "1025kg", "11.11.1111"),
    ShoppingItem("Ahmet", 100.09, "1025kg", "11.11.1111"),
    ShoppingItem("Yiğit", 100.09, "1025kg", "11.11.1111"),
    ShoppingItem("Pelin", 100.09, "1025kg", "11.11.1111"),
    ShoppingItem("Burhan", 100.09, "1025kg", "11.11.1111"),
  ];
  double get totalPrice {
    return items.fold(0.0, (sum,item) => sum + item.price);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithArrow(),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text("Creating New List: USER_ENTERED_NAME", style: TextStyle(fontWeight: FontWeight.bold)),

            ),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const[
                Text("Product Name", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Price", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Amount/Weight", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Expiry Date", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            )
          ),
          const SizedBox(height: 8,),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index){
                final item = items[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), 
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.name),
                      Text("${item.price}\$"),
                      Text(item.amount),
                      Text(item.expiry),
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
                            content: Text("Product: \"${deletedItem.name}\" is deleted.",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )
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
                              onPressed: (){
                                setState(() {
                                  items.insert(deletedIndex, deletedItem);
                                });
                              },
                            ),
                          ));
                        },
                      ),
                    ]
                  )
                );
              }
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("Current Total: ${totalPrice.toStringAsFixed(2)}\$"),
          ),
          ElevatedButton(
            onPressed: () async {final result = await Navigator.pushNamed(context, '/barcode_scan');
            if(result != null && result is ShoppingItem){
              setState(() {
                items.add(result);
              });
            }
            }, // add new item screen navigate,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 172, 219, 175),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text("Add New Item"),
          ),
          const SizedBox(height: 8,),
          ElevatedButton(
            onPressed: () {
              // go the the page that all lists are present

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 164, 226, 167),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: const Text("Save The Shopping List"),
          ),
          const SizedBox(height: 12,),
        ],

      ),
      bottomNavigationBar: AppNavBar(currentIndex: 1),
    );
  }
}

