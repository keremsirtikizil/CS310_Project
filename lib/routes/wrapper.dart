import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/user.dart';
import 'home.dart';
import 'login.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<MyUser?>();

    if (user == null) {
      return LoginPage();
    } else {
      return HomePage();
    }
  }
}
