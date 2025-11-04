import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RevenusLocationProprietaire extends StatelessWidget {
  // Pour cet exemple, les données sont en dur. Dans une vraie app, elles viendraient d'un ViewModel.
  final Map<String, double> monthlyRevenues = {
    'Jan': 50000.0,
    'Fév': 75000.0,
    'Mar': 120000.0,
    'Avr': 90000.0,
    'Mai': 150000.0,
    'Juin': 100000.0,
  };

  // Correction : Le mot-clé 'const' a été retiré ici
  RevenusLocationProprietaire({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BarChartGroupData> barGroups = [];
    final List<String> months = monthlyRevenues.keys.toList();

    // Assurer qu'il y a des données pour calculer le max
    final double maxRevenue = monthlyRevenues.isNotEmpty
        ? monthlyRevenues.values.reduce(
            (value, element) => value > element ? value : element
    )
        : 0;

    for (int i = 0; i < months.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: monthlyRevenues[months[i]]!,
              color: Theme.of(context).primaryColor,
              width: 15,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenus des 6 derniers mois',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(months[value.toInt()],
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      //tooltipBgColor: Colors.blueGrey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final String month = months[group.x.toInt()];
                        final double revenue = rod.toY;
                        return BarTooltipItem(
                          '$month\n',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${revenue.toStringAsFixed(0)} FCFA',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  maxY: maxRevenue * 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}