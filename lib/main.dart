import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';

// Models & Services
import 'model/user.dart';
import 'services/auth.dart';

// Routes (Screens)
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
import 'package:grocery_list/routes/checkListScreen.dart';
import 'package:grocery_list/routes/wrapper.dart'; 
import 'package:grocery_list/routes/change_password_screen.dart'; 

// Providers (State)
import 'state/fridge_provider.dart';
import 'state/shopping_list_provider.dart';
import 'state/auth_provider.dart';


final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //  New: StreamProvider for auth
        StreamProvider<MyUser?>.value(
          value: AuthService().user,
          initialData: null,
        ),

        //  Your existing state providers
        ChangeNotifierProvider(create: (_) => FridgeProvider()),
        ChangeNotifierProvider(create: (_) => ShoppingListProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider())

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Grocery+',
        theme: ThemeData(fontFamily: 'Poppins'),

        initialRoute: "/wrapper",
        routes: {
          "/wrapper": (context) => const Wrapper(),
          "/login": (context) => LoginPage(),
          "/signup": (context) => SignUp(),
          "/forgotPassword": (context) => forgotPassword(),
          "/home": (context) => HomePage(),
          "/financing": (context) => ExpensesScreen(),
          "/add": (context) => ChecklistScreen(),
          "/inventory": (context) => InventoryPage(),
          "/newListCreation": (context) => NewListCreation(),
          "/barcode_scan": (context) => BarcodeScannerScreen(),
          "/product-details": (context) => ProductDetails(),
          "/settings": (context) => SettingsPage(),
          "/recipes": (context) => RecipePage(),
          '/change-password': (context) => ChangePasswordScreen(), // NEW
        },
      ),
    );
  }
}
