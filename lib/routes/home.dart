import 'package:flutter/material.dart';
import 'package:grocery_list/utils/AppColors.dart';
import 'package:grocery_list/utils/navbar.dart';
import 'package:grocery_list/utils/appBar.dart';
import 'package:provider/provider.dart';
import 'package:grocery_list/state/fridge_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      final fridgeProvider = Provider.of<FridgeProvider>(context, listen: false);
      fridgeProvider.loadRecentPurchases();
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fridgeProvider = Provider.of<FridgeProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBarWithArrow(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Welcome to Grocery+",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Recent Purchases",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 12),
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

                // Show recent purchases
                ...fridgeProvider.recentPurchases.map((item) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.boxColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text(item['name'] ?? '')),
                          Expanded(child: Text("${item['price']?.toStringAsFixed(2) ?? '0.00'}\$")),
                          Expanded(child: Text(item['amount']?.toString() ?? '')),
                          Expanded(child: Text(item['purchasedAt'] ?? '')),
                        ],
                      ),
                    )),

                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(167, 211, 151, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Text("Weekly Spending: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("${fridgeProvider.weeklySpending.toStringAsFixed(2)}\$"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppNavBar(currentIndex: 2),
    );
  }
}
