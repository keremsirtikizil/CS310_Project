import 'package:flutter/material.dart';
import 'package:grocery_list/utils/AppColors.dart';
import 'package:grocery_list/utils/navbar.dart';
import 'package:grocery_list/utils/appBar.dart';
class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Dummy data for recent purchases
  final List<Map<String, String>> purchases = [
    {
      'product': 'Apple',
      'price': '3.99\$',
      'amount': '1kg',
      'date': '30.09.2004',
    },
    {
      'product': 'Strawberry',
      'price': '3.99\$',
      'amount': '1 kg',
      'date': '30.09.2004',
    },
    {
      'product': 'Apple',
      'price': '3.99\$',
      'amount': '1 kg',
      'date': '30.09.2004',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBarWithArrow(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo

              const SizedBox(height: 10),

              const Text(
                "Welcome to Grocery+",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recent Purchases",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Table Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.boxColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Expanded(child: Text("Product Name", style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text("Price", style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text("Purchase Date", style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Table Rows
              ...purchases.map(
                (item) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.boxColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(item['product'] ?? '')),
                      Expanded(child: Text(item['price'] ?? '')),
                      Expanded(child: Text(item['amount'] ?? '')),
                      Expanded(child: Text(item['date'] ?? '')),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Weekly Spending
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(167, 211, 151, 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Text(
                      "Weekly Spending: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("11.97\$"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
bottomNavigationBar: AppNavBar(currentIndex: 2)

    );
  }
}
