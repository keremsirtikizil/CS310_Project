import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FridgeProvider extends ChangeNotifier {
  List<Map<String, dynamic>> recentPurchases = [];
  double weeklySpending = 0.0;

  Future<void> loadRecentPurchases() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));

    final snapshot = await FirebaseFirestore.instance
        .collection("fridgeItems")
        .doc(uid)
        .collection("items")
        .where("purchasedAt", isGreaterThanOrEqualTo: oneWeekAgo)
        .orderBy("purchasedAt", descending: true)
        .get();

    recentPurchases = snapshot.docs.map((doc) {
      final data = doc.data();
      final timestamp = data['purchasedAt'] as Timestamp?;
      final dateStr = timestamp != null
          ? DateFormat('dd.MM.yyyy').format(timestamp.toDate())
          : '';
      return {
        'name': data['name'] ?? '',
        'price': (data['price'] ?? 0).toDouble(),
        'amount': data['amount'] ?? '',
        'purchasedAt': dateStr,
      };
    }).toList();

    weeklySpending = recentPurchases.fold(0.0, (sum, item) {
      final price = item['price'] ?? 0.0;
      final amountRaw = item['amount'] ?? 1;
      final amount = amountRaw is num ? amountRaw : int.tryParse(amountRaw.toString()) ?? 1;
      return sum + (price * amount);
    });
    notifyListeners();
  }
}