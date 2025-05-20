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
    final dailySpending = {
      'Mon': 0.0, 'Tue': 0.0, 'Wed': 0.0,
      'Thu': 0.0, 'Fri': 0.0, 'Sat': 0.0, 'Sun': 0.0,
    };

    final now = DateTime.now();
    final startOfWeek = _getStartOfWeek(now);
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    for (var purchase in purchases) {
      final dateStr = purchase['purchasedAt'] as String;
      if (dateStr.isNotEmpty) {
        final date = DateFormat('dd.MM.yyyy').parse(dateStr);
        if (date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            date.isBefore(endOfWeek)) {
          final dayOfWeek = DateFormat('EEE').format(date);
          final price = (purchase['price'] ?? 0.0).toDouble();
          dailySpending[dayOfWeek] = (dailySpending[dayOfWeek] ?? 0) + price;
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
    final hasSpending = dailySpending.values.any((v) => v > 0);
    final averageSpending = _calculateAverageSpending(dailySpending);
    final maxSpending = dailySpending.values.fold(0.0, (max, value) => value > max ? value : max);

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBarWithArrow(),
      body: Column(
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your expenses this week:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  _getWeekRange(),
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          if (!hasSpending)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
              child: Text(
                'No spending recorded this week.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            )
          else ...[
            // Pie Chart
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: dailySpending.entries.map((entry) {
                      return PieChartSectionData(
                        value: entry.value,
                        color: AppColors.boxColor.withOpacity(
                          0.3 + 0.1 * dailySpending.keys.toList().indexOf(entry.key),
                        ),
                        title: entry.key,
                        radius: 50,
                      );
                    }).toList(),
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
                    maxY: maxSpending * 1.2,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            return Text(days[value.toInt()], style: const TextStyle(fontSize: 12));
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text('\$${value.toInt()}', style: const TextStyle(fontSize: 12));
                          },
                          interval: maxSpending > 0 ? maxSpending / 5 : 20,
                        ),
                      ),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(7, (index) {
                      final day = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index];
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: dailySpending[day] ?? 0,
                            color: AppColors.boxColor,
                            width: 20,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }),
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
        ],
      ),
      bottomNavigationBar: AppNavBar(currentIndex: 0),
    );
  }
}
