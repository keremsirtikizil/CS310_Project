import 'package:flutter/material.dart';
import 'package:grocery_list/utils/appBar.dart';
import 'package:grocery_list/utils/navbar.dart';
class FinancingPage extends StatelessWidget {
  const FinancingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithArrow(),
      body: Column(
        children: [
          Center(child: Text('Financing Page')),
          ElevatedButton(onPressed: () {Navigator.pop(context);}, child: Text("GO BACK"))
        ],
      ),
      bottomNavigationBar: AppNavBar(currentIndex: 0),
    );
  }
}
