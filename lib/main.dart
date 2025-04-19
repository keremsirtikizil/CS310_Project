import 'package:flutter/material.dart';
import 'package:grocery_list/routes/checkListScreen.dart';
import 'package:grocery_list/routes/home.dart';
import 'package:grocery_list/routes/login.dart';
import 'package:grocery_list/routes/expensesScreen.dart';
import 'package:grocery_list/routes/inventory.dart';
import 'package:grocery_list/routes/newListCreation.dart';
import 'package:grocery_list/routes/settings.dart';
import 'package:grocery_list/routes/barcodeScannerScreen.dart';
import 'package:grocery_list/routes/signup.dart';
import 'package:grocery_list/routes/forgotpassword.dart';
import 'package:grocery_list/routes/productDetails.dart';
import 'package:grocery_list/routes/recipes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery+',
      initialRoute: "/login",
      theme: ThemeData(
        fontFamily: 'Poppins'
      ),
      routes: {"/login":(context)=>LoginPage(),
              "/home":(context)=>HomePage(),
              "/financing":(context)=>ExpensesScreen(),
              "/add":(context)=> ChecklistScreen(),
              "/inventory":(context)=>InventoryPage(),
              "/settings":(context)=>SettingsPage(),
              "/forgotPassword":(context)=>forgotPassword(),
              "/signup":(context)=>SignUp(),
              "/newListCreation": (context) => NewListCreation(),
              "/barcode_scan": (context) => BarcodeScannerScreen(),
              "/product-details": (context) => ProductDetails(),
              "/recipes": (context) => RecipePage(),
      },

    
    );
  }
}
