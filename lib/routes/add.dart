import 'package:flutter/material.dart';
import 'package:grocery_list/utils/appBar.dart';
import 'package:grocery_list/utils/navbar.dart';
class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithArrow(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(child: Text('Add Page')),
          ElevatedButton(onPressed: () {Navigator.pushNamed(context, '/newListCreation');}, child: Text("Create new list."))
        ],
      ),
      bottomNavigationBar: AppNavBar(currentIndex: 1),

    );
  }
}
