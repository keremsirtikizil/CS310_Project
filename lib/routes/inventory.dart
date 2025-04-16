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

  final List<Map<String, dynamic>> items = [
    {
      'name': 'Milk',
      'amount': '2 L',
      'date': '22.03.2025',
      'image': 'assets/images/milk.png',
      'statusColor': Color(0xFFBE0E0E),
    },
    {
      'name': 'Egg',
      'amount': '24 piece',
      'date': '01.05.2025',
      'image': 'assets/images/egg.png',
      'statusColor': Color(0xFF2C5F2D),
    },
    {
      'name': 'Tomato',
      'amount': '3 kg',
      'date': '28.03.2025',
      'image': 'assets/images/tomato.png',
      'statusColor': Color(0xFFEB7B30),
    },
    {
      'name': 'Cheese',
      'amount': '2 piece',
      'date': '21.05.2025',
      'image': 'assets/images/cheese.png',
      'statusColor': Color(0xFF2C5F2D),
    },
    {
      'name': 'Lettuce',
      'amount': '1 piece',
      'date': '21.05.2025',
      'image': 'assets/images/lettuce.png',
      'statusColor': Color(0xFF2C5F2D),
    },
    {
      'name': 'Chicken',
      'amount': '1 piece',
      'date': '19.04.2025',
      'image': 'assets/images/chicken.png',
      'statusColor': Color(0xFFBE0E0E),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBarWithArrow(),
      ),
      body: Stack(
        children:[
        SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo

              const SizedBox(height: 2),

              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
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
                  SizedBox(width: 48),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child:SizedBox(
                        height: 36,
                        child: TextField(
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Search...',
                            prefixIcon: Icon(Icons.search, size: 18),
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
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
                        icon: Icon(Icons.tune),
                        onPressed: () {
                        },
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
                        color: Color(0xFFEB7B30),
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
                child: GridView.builder(
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 2),
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
                                backgroundColor: item['statusColor'],
                                radius: 8,
                              ),
                            ),
                          ),

                          Image.asset(
                            item['image'],
                            height: 128,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            item['amount'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            item['date'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
          Positioned(
            left: 16,
            bottom: 40,
            child: FloatingActionButton(
              backgroundColor: Color(0xFF2C5F2D),
              elevation: 3,
              onPressed: () {
                Navigator.pushNamed(context, '/recipes');
              },
              child: Icon(Icons.menu_book, color: Colors.white),
            ),
          ),
      ],

      ),

      bottomNavigationBar: AppNavBar(currentIndex: 3),
    );
  }
}
