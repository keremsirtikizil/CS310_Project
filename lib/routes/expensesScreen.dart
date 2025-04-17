import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:grocery_plus/theme/app_colors.dart';
import '../widgets/expense_pie_chart.dart';
import '../widgets/expense_bar_chart.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  void _onNavigationItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0: // Expenses
        break; // Already in expenses screen
      case 1: // Add
        Navigator.pushNamed(context, '/add');
        break;
      case 2: // Items
        Navigator.pushNamed(context, '/inventory');
        break;
      case 3: // Settings
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
          elevation: 0,
          flexibleSpace: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Expanded(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/images/grocery+_logo.png'),
                              height: 40,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Grocery+',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Expenses title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your expenses this week:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          
          // Pie Chart
          const SizedBox(height: 20),
          const Expanded(
            flex: 2,
            child: ExpensePieChart(),
          ),
          
          // Bar Chart
          const Expanded(
            flex: 2,
            child: ExpenseBarChart(),
          ),
          
          // Average spending card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Average dollars spent in a day: \$54.29',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        currentIndex: 0, // Expenses tab
        onTap: (index) => _onNavigationItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
} 
