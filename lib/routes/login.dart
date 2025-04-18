import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:grocery_list/utils/AppColors.dart';
import 'package:grocery_list/routes/loadingOverlay.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  String _email = '';
  String _password = '';

  Future<void> _showErrorDialog(String title, String message) async {
    bool isAndroid = Platform.isAndroid;
   return showDialog(context: context,
        builder: (BuildContext context) {
          if (isAndroid) {
            return AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(onPressed: () {
                  Navigator.pop(context);
                },
                    child: Text('OK'))
              ],
            );
          }
          else {
            return CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                },
                    child: Text('OK'))
              ],
            );
          }
        });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                SizedBox(
                  height: 120,
                  child: Image.asset(
                    'assets/images/grocery+_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 60),

                // Email Field
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email:',
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: 'Type your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value != null ) {
                      if(value.isEmpty){
                        return "Email can't be empty";
                      }
                      else if (!EmailValidator.validate(value!)) {
                      return "Enter a valid email";
                       }   
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value??'';
                  },
                ),

                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password:',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    hintText: 'Type your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value != null) {
                          if (value.isEmpty) {
                            return 'Password cannot be empty';
                  
                          }
                          if (value.length < 6) {
                            return 'Passoword is too short';
                          }
                        }
                        return null;
                    },

                  onSaved: (value) {
                        _password = value ?? '';
                    }
                ),
              
                const SizedBox(height: 20),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () async {

                      await showLoadingTransition(context, durationMs: 1500);
                      if (_formKey.currentState!.validate()) {

                        print('Email $_email Password $_password');
                        Navigator.pushNamedAndRemoveUntil(context, "/home", (routes)=>false);
                        _formKey.currentState!.save();

                      }
                      else {
                        _showErrorDialog('Form Error', 'Your form is invalid');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                    ),
                    child: const Text("Login", style: TextStyle(color: Colors.white)),
                  ),
                ),

                const SizedBox(height: 20),

                // Bottom Links
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {Navigator.pushNamed(context, "/signup");},
                      child: const Text(
                        "Don’t have an account?",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {Navigator.pushNamed(context, "/forgotPassword");},
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    )
    );
  }
}
