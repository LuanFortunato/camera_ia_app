import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../model/count.dart';

class ProductsChart extends StatelessWidget {
  const ProductsChart({
    super.key,
    required this.counts,
  });

  final List<Count> counts;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      createData(counts),
    );
  }
}

BarChartGroupData makeGroupData(
  int x,
  double y,
) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y,
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
        width: 22,
      ),
    ],
  );
}

Widget getTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  List<String> days = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  Widget text = Text(
    days[value.toInt()],
    style: style,
  );

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 16,
    child: text,
  );
}

double roundTo10(int num) {
  while (num % 10 != 0) {
    num += 1;
  }
  return num.toDouble();
}

BarChartData createData(List<Count> counts) {
  return BarChartData(
    maxY: roundTo10(counts.first.quantity),
    barTouchData: BarTouchData(
      enabled: true,
    ),
    titlesData: const FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: getTitles,
          reservedSize: 38,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          reservedSize: 50,
          showTitles: true,
        ),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
    ),
    borderData: FlBorderData(
      show: false,
    ),
    barGroups: List.generate(
      counts.length <= 10 ? counts.length : 10,
      (i) => makeGroupData(
        i,
        counts[i].quantity.toDouble(),
      ),
    ),
    gridData: const FlGridData(show: false),
  );
}
