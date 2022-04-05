import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sidekick/pages/bart_chart_data.dart';

class BarChartContent extends StatelessWidget {
  const BarChartContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        gridData: FlGridData(
          show: false,
        ),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) {
              return TextStyle(
                  color: Theme.of(context).dialogBackgroundColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold);
            },
            getTitles: (value) {
              switch (value.toInt()) {
                case 1:
                  return 'Lun';
                case 2:
                  return 'Mar';
                case 3:
                  return 'Mer';
                case 4:
                  return 'Jeu';
                case 5:
                  return 'Ven';
                case 6:
                  return 'Sam';
                case 7:
                  return 'Dim';
              }
              return '';
            },
          ),
          leftTitles: SideTitles(
            interval: 1000,
            showTitles: true,
            getTextStyles: (context, value) {
              return TextStyle(
                  color: Theme.of(context).dialogBackgroundColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold);
            },
            getTitles: (value) {
              if (value.toInt() == 0) {
                return 'Kcal';
              } else {
                return value.toInt().toString().substring(0,1) + "K";
              }
            },
          ),

          rightTitles: SideTitles(
            showTitles: false,
          ),
          topTitles: SideTitles(
            showTitles: false,
          ),
        ),
        borderData: FlBorderData(
            show: false,
        ),
        barGroups: barChartGroupData,
        maxY: 3500,
        barTouchData: barTouchData,
      ),
    );
  }
  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.transparent,
      tooltipPadding: const EdgeInsets.all(0),
      tooltipMargin: 8,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.y.round().toString(),
          const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );
}
