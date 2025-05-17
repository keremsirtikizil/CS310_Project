import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShoppingListProvider with ChangeNotifier {
  List<Map<String, dynamic>> items = [];
  double currentTotal = 0.0;

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

    currentTotal = loadedItems.fold(0, (sum, item) => sum + item['totalPrice']);

    items = loadedItems;
    notifyListeners();
  }

  Future<void> markAsPurchased(BuildContext context, Map<String, dynamic> item, int index) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Purchase"),
        content: const Text("Move items to fridge?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Confirm")),
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

    await FirebaseFirestore.instance.collection('shoppingLists').doc(item['id']).delete();

    items.removeAt(index);
    currentTotal = items.fold(0, (sum, item) => sum + (item['totalPrice'] as num).toDouble());
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Moved to fridge")),
    );
  }

  Future<void> deleteList(BuildContext context, String docId, int index) async {
    await FirebaseFirestore.instance.collection('shoppingLists').doc(docId).delete();

    items.removeAt(index);
    currentTotal = items.fold(0, (sum, item) => sum + (item['totalPrice'] as num).toDouble());
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Deleted list")),
    );
  }
}
