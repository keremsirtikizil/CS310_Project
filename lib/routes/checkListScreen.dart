import 'package:flutter/material.dart';
import 'package:grocery_list/utils/AppColors.dart';
import 'package:grocery_list/utils/navbar.dart';
import 'package:grocery_list/utils/appbar.dart';
class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  double currentTotal = 33.76;
  List<Map<String, dynamic>> items = [
    {
      'name': 'Product List 1',
      'totalPrice': 2.99,
    },
    {
      'name': 'Product List 2',
      'totalPrice': 6.99,
    },
    {
      'name': 'Product List 3',
      'totalPrice': 22.99,
    }

  ];

  void _addNewList() {
    Navigator.pushNamed(context, '/add');
  }



  @override
  void dispose() {
    super.dispose();
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
              // Header with back button and title
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Shopping List',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // For balance
                ],
              ),
              const SizedBox(height: 20),
              
              // Create New List Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/newListCreation");
                },
                child: const Text(
                  'Create New List',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // List of items
              Expanded(
                child: ListView.builder(
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
                                  'Total Price: \$${item['totalPrice'].toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                items.removeAt(index);
                                currentTotal = items.fold(
                                  0,
                                  (sum, item) => sum + (item['totalPrice'] as double),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // Total amount
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${currentTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppNavBar(currentIndex: 1)
    );
  }
} 
