import 'package:flutter/material.dart';
import 'package:grocery_list/routes/home.dart';
import 'package:grocery_list/routes/login.dart';
import 'package:grocery_list/routes/add.dart';
import 'package:grocery_list/routes/financing.dart';
import 'package:grocery_list/routes/inventory.dart';
import 'package:grocery_list/routes/settings.dart';

import 'package:grocery_list/routes/signup.dart';
import 'package:grocery_list/routes/forgotpassword.dart';
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
      routes: {"/login":(context)=>LoginPage(),
              "/home":(context)=>HomePage(),
              "/financing":(context)=>FinancingPage(),
              "/add":(context)=>AddPage(),
              "/inventory":(context)=>InventoryPage(),
              "/settings":(context)=>SettingsPage(),
              "/forgotPassword":(context)=>forgotPassword(),
              "/signup":(context)=>SignUp(),



      },

    
    );
  }
}
