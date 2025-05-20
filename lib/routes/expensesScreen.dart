import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:grocery_list/utils/AppColors.dart';
import 'package:grocery_list/utils/navbar.dart';
import 'package:grocery_list/utils/appBar.dart';
import 'package:provider/provider.dart';
import 'package:grocery_list/state/fridge_provider.dart';
import 'package:intl/intl.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      final fridgeProvider = Provider.of<FridgeProvider>(context, listen: false);
      fridgeProvider.loadRecentPurchases();
      _isLoaded = true;
    }
  }

  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  Map<String, double> _calculateDailySpending(List<Map<String, dynamic>> purchases) {
    Map<String, double> dailySpending = {
      'Mon': 0.0,
      'Tue': 0.0,
      'Wed': 0.0,
      'Thu': 0.0,
      'Fri': 0.0,
      'Sat': 0.0,
      'Sun': 0.0,
    };

    final now = DateTime.now();
    final startOfWeek = _getStartOfWeek(now);
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    for (var purchase in purchases) {
      final dateStr = purchase['purchasedAt'] as String;
      if (dateStr.isNotEmpty) {
        final date = DateFormat('dd.MM.yyyy').parse(dateStr);
        
        // Only include purchases from the current week
        if (date.isAfter(startOfWeek.subtract(const Duration(days: 1))) && 
            date.isBefore(endOfWeek)) {
          final dayOfWeek = DateFormat('EEE').format(date);
          final price = purchase['price'] as double;
          final amountRaw = purchase['amount'];
          final amount = amountRaw is num ? amountRaw : int.tryParse(amountRaw.toString()) ?? 1;
          
          dailySpending[dayOfWeek] = (dailySpending[dayOfWeek] ?? 0) + (price * amount);
        }
      }
    }

    return dailySpending;
  }

  double _calculateAverageSpending(Map<String, double> dailySpending) {
    final total = dailySpending.values.fold(0.0, (sum, value) => sum + value);
    final daysWithSpending = dailySpending.values.where((value) => value > 0).length;
    return daysWithSpending > 0 ? total / daysWithSpending : 0;
  }

  String _getWeekRange() {
    final now = DateTime.now();
    final startOfWeek = _getStartOfWeek(now);
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    final dateFormat = DateFormat('MMM d');
    return '${dateFormat.format(startOfWeek)} - ${dateFormat.format(endOfWeek)}';
  }

  @override
  Widget build(BuildContext context) {
    final fridgeProvider = Provider.of<FridgeProvider>(context);
    final dailySpending = _calculateDailySpending(fridgeProvider.recentPurchases);
    final averageSpending = _calculateAverageSpending(dailySpending);
    final maxSpending = dailySpending.values.fold(0.0, (max, value) => value > max ? value : max);

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBarWithArrow(),
      body: Column(
        children: [
          // Expenses title with week range
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your expenses this week:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  _getWeekRange(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
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
                      value: dailySpending['Mon'] ?? 0,
                      color: AppColors.boxColor.withOpacity(0.3),
                      title: 'Mon',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: dailySpending['Tue'] ?? 0,
                      color: AppColors.boxColor.withOpacity(0.4),
                      title: 'Tue',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: dailySpending['Wed'] ?? 0,
                      color: AppColors.boxColor.withOpacity(0.5),
                      title: 'Wed',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: dailySpending['Thu'] ?? 0,
                      color: AppColors.boxColor.withOpacity(0.6),
                      title: 'Thu',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: dailySpending['Fri'] ?? 0,
                      color: AppColors.boxColor.withOpacity(0.7),
                      title: 'Fri',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: dailySpending['Sat'] ?? 0,
                      color: AppColors.boxColor.withOpacity(0.8),
                      title: 'Sat',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: dailySpending['Sun'] ?? 0,
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
                  maxY: maxSpending * 1.2, // Add 20% padding
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
                        interval: maxSpending > 0 ? maxSpending / 5 : 20,
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
                          toY: dailySpending['Mon'] ?? 0,
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
                          toY: dailySpending['Tue'] ?? 0,
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
                          toY: dailySpending['Wed'] ?? 0,
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
                          toY: dailySpending['Thu'] ?? 0,
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
                          toY: dailySpending['Fri'] ?? 0,
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
                          toY: dailySpending['Sat'] ?? 0,
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
                          toY: dailySpending['Sun'] ?? 0,
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
              child: Text(
                'Average dollars spent in a day: \$${averageSpending.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppNavBar(currentIndex: 0)
    );
  }
} 
