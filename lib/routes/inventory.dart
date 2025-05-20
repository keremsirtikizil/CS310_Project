import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list/utils/AppColors.dart';
import 'package:grocery_list/utils/appBar.dart';
import 'package:grocery_list/utils/navbar.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {

  final User? user = FirebaseAuth.instance.currentUser;

  late final Stream<QuerySnapshot> itemStream;

  @override
  void initState() {
    super.initState();

    if (user != null) {
      itemStream = FirebaseFirestore.instance
          .collection('fridgeItems')
          .doc(user!.uid)
          .collection('items')
          .snapshots();
    } else {
    }
  }

  DateTime? parseExpiry(String? dateStr) {
    if (dateStr == null) return null;
    try {
      final parts = dateStr.split('-');
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (_) {
      return null;
    }
  }

  Color determineStatusColor(DateTime? expiryDate) {
    if (expiryDate == null) return Colors.grey;
    final today = DateTime.now();
    final daysLeft = expiryDate.difference(today).inDays;

    if (daysLeft <= 7) {
      return const Color(0xFFBE0E0E);
    } else if (daysLeft <= 12) {
      return const Color(0xFFEB7B30);
    } else {
      return const Color(0xFF2C5F2D);
    }
  }

  String getCategoryImage(String category) {
    switch (category) {
      case 'Dairy':
        return 'assets/images/dairy.png';
      case 'Fruits & Vegetables':
        return 'assets/images/fruit-veg.png';
      case 'Meat & Fish':
        return 'assets/images/meat-fish.png';
      case 'Beverages':
        return 'assets/images/beverages.png';
      default:
        return 'assets/images/dairy.png';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBarWithArrow(),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "My Fridge",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 36,
                            child: TextField(
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Search...',
                                prefixIcon: const Icon(Icons.search, size: 18),
                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 1),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.tune),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Color(0xFFBE0E0E),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '1-7',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 30,
                            color: const Color(0xFFEB7B30),
                            alignment: Alignment.center,
                            child: const Text(
                              '7-12',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2C5F2D),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '12-20',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: itemStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text("No items found."));
                        }

                        final docs = snapshot.data!.docs
                            .where((doc) => doc['purchasedAt'] != null)
                            .toList();

                        if (docs.isEmpty) {
                          return Center(child: Text("No purchased items in fridge."));
                        }

                        return GridView.builder(
                          itemCount: docs.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.8,
                          ),
                          itemBuilder: (context, index) {
                            final data = docs[index].data() as Map<String, dynamic>;
                            final name = data['category'] ?? "Unnamed";
                            final amount = data['amount'] ?? "-";
                            final expiryStr = data['expiry'];
                            final expiryDate = parseExpiry(expiryStr);
                            final color = determineStatusColor(expiryDate);

                            final category = data['category'] ?? 'Unknown';
                            final imagePath = getCategoryImage(category);

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: CircleAvatar(
                                        backgroundColor: color,
                                        radius: 8,
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    imagePath,
                                    height: 128,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text(amount, style: const TextStyle(color: Colors.grey)),
                                  Text(expiryStr ?? '-', style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )

                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 40,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF2C5F2D),
              elevation: 3,
              onPressed: () {
                Navigator.pushNamed(context, '/recipes');
              },
              child: const Icon(Icons.menu_book, color: Colors.white),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppNavBar(currentIndex: 3),
    );
  }
}
