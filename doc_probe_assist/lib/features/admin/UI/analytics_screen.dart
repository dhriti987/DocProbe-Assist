import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 15);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mon';
        break;
      case 1:
        text = 'Tue';
        break;
      case 2:
        text = 'Wed';
        break;
      case 3:
        text = 'Thurs';
        break;
      case 4:
        text = 'Fri';
        break;
      case 5:
        text = 'Sat';
        break;
      case 6:
        text = 'Sun';
        break;
      default:
        text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weekly Report',
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: good_resp_color,
                            border: Border.all()),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Good Response",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bad_resp_color,
                            border: Border.all()),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Bad Response",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: no_resp_color,
                            border: Border.all()),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "No Response",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: 900,
                    height: 500,
                    child: AspectRatio(
                      aspectRatio: 2,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceEvenly,
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                    interval: 10,
                                    showTitles: true,
                                    reservedSize: 35)),
                            rightTitles: const AxisTitles(),
                            topTitles: const AxisTitles(),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: bottomTitles,
                                reservedSize: 30,
                              ),
                            ),
                          ),
                          barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                  var color = good_resp_color;
                                  if (rodIndex == 1) {
                                    color = bad_resp_color;
                                  } else if (rodIndex == 2) {
                                    color = no_resp_color;
                                  }
                                  return BarTooltipItem(
                                      '${(rod.toY - rod.fromY).toInt()}',
                                      TextStyle(color: color));
                                },
                              )),
                          borderData: FlBorderData(
                            border: Border(
                              bottom: BorderSide(color: Colors.black, width: 4),
                              left: const BorderSide(
                                  color: Colors.black, width: 4),
                              right:
                                  const BorderSide(color: Colors.transparent),
                              top: const BorderSide(color: Colors.transparent),
                            ),
                          ),
                          gridData: const FlGridData(show: true),
                          barGroups: [
                            generateGroupData(0, 20 + 10, 30 - 20, 40),
                            generateGroupData(1, 20 + 10, 25 - 20, 10),
                            generateGroupData(2, 15 + 10, 30 - 20, 20),
                            generateGroupData(3, 30 + 10, 40 - 20, 30),
                            generateGroupData(4, 10 + 10, 30 - 20, 30),
                            generateGroupData(5, 23 + 10, 50 - 20, 10),
                            generateGroupData(6, 10 + 10, 30 - 20, 2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width / 8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: 300,
                    height: 135,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Total Documents",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "152",
                          style: TextStyle(fontSize: 64),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: 300,
                    height: 135,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Embeded Documents",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "133",
                          style: TextStyle(fontSize: 64),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: 300,
                    height: 135,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Total Users",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "211",
                          style: TextStyle(fontSize: 64),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: 300,
                    height: 155,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Total Question",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "Asked This Week",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "124",
                          style: TextStyle(fontSize: 64),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

final good_resp_color = Colors.green[300];
final no_resp_color = Colors.grey[300];
final bad_resp_color = Colors.red[300];
final betweenSpace = 0.0;

BarChartGroupData generateGroupData(
  int x_day,
  double good_response,
  double bad_response,
  double no_response,
) {
  return BarChartGroupData(
    x: x_day,
    groupVertically: true,
    barRods: [
      BarChartRodData(
        borderRadius: BorderRadius.zero,
        fromY: 0,
        toY: good_response,
        color: good_resp_color,
        width: 25,
      ),
      BarChartRodData(
        borderRadius: BorderRadius.zero,
        fromY: good_response + betweenSpace,
        toY: good_response + betweenSpace + bad_response,
        color: bad_resp_color,
        width: 25,
      ),
      BarChartRodData(
        borderRadius: BorderRadius.zero,
        fromY: good_response + betweenSpace + bad_response + betweenSpace,
        toY: good_response +
            betweenSpace +
            bad_response +
            betweenSpace +
            no_response,
        color: no_resp_color,
        width: 25,
      ),
    ],
  );
}
