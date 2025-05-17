import 'package:flutter/material.dart';
import 'package:grocery_list/utils/AppColors.dart';
import 'package:grocery_list/utils/appbar.dart';

class ShoppingListDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> shoppingList;
  const ShoppingListDetailsScreen({super.key, required this.shoppingList});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> items = shoppingList['items'] ?? [];

    return Scaffold(
      appBar: const AppBarWithArrow(),
      backgroundColor: AppColors.mainBackground,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                shoppingList['name']?.toString() ?? 'Shopping List',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text("No items found in this list."))
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final price = (item['price'] as num?)?.toStringAsFixed(2) ?? '0.00';
                        final name = item['name']?.toString() ?? 'Unnamed Item';
                        final amount = item['amount']?.toString() ?? '-';
                        final expiry = item['expiry']?.toString() ?? '-';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.boxColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text("Price: \$$price"),
                              Text("Amount/Weight: $amount"),
                              Text("Expiry Date: $expiry"),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
