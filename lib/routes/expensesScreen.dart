import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:grocery_plus/utils/AppColors.dart';

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
      backgroundColor: AppColors.mainBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.appBarColor,
          elevation: 0,
          flexibleSpace: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
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
                                color: Colors.black,
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
                  color: Colors.black,
                ),
              ),
            ),
          ),
          
          // Pie Chart
          const SizedBox(height: 20),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      value: 15, // Monday
                      color: AppColors.boxColor.withOpacity(0.3),
                      title: 'Mon',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: 10, // Tuesday
                      color: AppColors.boxColor.withOpacity(0.4),
                      title: 'Tue',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: 20, // Wednesday
                      color: AppColors.boxColor.withOpacity(0.5),
                      title: 'Wed',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: 8, // Thursday
                      color: AppColors.boxColor.withOpacity(0.6),
                      title: 'Thu',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: 25, // Friday
                      color: AppColors.boxColor.withOpacity(0.7),
                      title: 'Fri',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: 30, // Saturday
                      color: AppColors.boxColor.withOpacity(0.8),
                      title: 'Sat',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: 15, // Sunday
                      color: AppColors.boxColor.withOpacity(0.9),
                      title: 'Sun',
                      radius: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Bar Chart
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          return Text(
                            days[value.toInt()],
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                        interval: 20,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: 45,
                          color: AppColors.boxColor,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: 30,
                          color: AppColors.boxColor,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: 60,
                          color: AppColors.boxColor,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(
                          toY: 25,
                          color: AppColors.boxColor,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 4,
                      barRods: [
                        BarChartRodData(
                          toY: 80,
                          color: AppColors.boxColor,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 5,
                      barRods: [
                        BarChartRodData(
                          toY: 90,
                          color: AppColors.boxColor,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 6,
                      barRods: [
                        BarChartRodData(
                          toY: 50,
                          color: AppColors.boxColor,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Average spending card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.boxColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Average dollars spent in a day: \$54.29',
                style: TextStyle(
                  color: Colors.black,
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
        backgroundColor: AppColors.navbarColor,
        selectedItemColor: AppColors.buttonColor,
        unselectedItemColor: Colors.black54,
        currentIndex: 0,
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
