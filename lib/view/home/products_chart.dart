import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProductsChart extends StatelessWidget {
  const ProductsChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      randomData(),
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
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
    'S',
    'S',
    'S',
    'S',
    'S',
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

BarChartData randomData() {
  return BarChartData(
    maxY: 300,
    barTouchData: BarTouchData(
      enabled: false,
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
          reservedSize: 0,
          showTitles: false,
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
      10,
      (i) => makeGroupData(
        i,
        Random().nextInt(290).toDouble() + 10,
      ),
    ),
    gridData: const FlGridData(show: false),
  );
}
