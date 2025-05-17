import 'package:flutter/material.dart';
import 'package:grocery_list/utils/AppColors.dart';
import 'package:grocery_list/utils/navbar.dart';
import 'package:grocery_list/utils/appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> purchases = [];
  double totalSpent = 0.0;

  @override
  void initState() {
    super.initState();
    fetchRecentPurchases();
  }

  Future<void> fetchRecentPurchases() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));

    final snapshot = await FirebaseFirestore.instance
        .collection('fridgeItems')
        .doc(uid)
        .collection('items')
        .where('purchasedAt', isGreaterThanOrEqualTo: oneWeekAgo)
        .orderBy('purchasedAt', descending: true)
        .get();

    final List<Map<String, dynamic>> fetched = snapshot.docs.map((doc) {
      final data = doc.data();
      final date = (data['purchasedAt'] as Timestamp?)?.toDate();
      return {
        'product': data['name'] ?? '-',
        'price': "\$${(data['price'] ?? 0).toStringAsFixed(2)}",
        'amount': data['amount'] ?? '-',
        'date': date != null ? "${date.day}.${date.month}.${date.year}" : '-',
      };
    }).toList();

    double total = 0;
    for (final item in snapshot.docs) {
      final data = item.data();
      final price = (data['price'] ?? 0).toDouble();
      final amount = double.tryParse(data['amount']?.toString() ?? '1') ?? 1;
      total += price * amount;
    }

    setState(() {
      purchases = fetched;
      totalSpent = total;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.boxColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                          child: Text("Product Name",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text("Price",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text("Amount",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text("Date",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ...purchases.map(
                  (item) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 8),
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(167, 211, 151, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "Weekly Spending: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("${totalSpent.toStringAsFixed(2)}\$"),
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