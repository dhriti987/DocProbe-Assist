import 'dart:math';

import 'package:doc_probe_assist/features/admin/bloc/admin_bloc.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminBloc adminBloc = sl.get<AdminBloc>();
  List<String> bottomTilesDates = ['1', '2', '3', '4', '5', '6', '7'];
  List<dynamic> weeklyFeedbackNum = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0]
  ];
  int totalDocuments = 0;
  int embeddedDocuments = 0;
  int totalUsers = 0;
  int weeklyTotalQues = 0;
  int totalQues = 0;
  int goodResponse = 0;
  int badResponse = 0;

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 15);
    String text = bottomTilesDates[value.toInt()];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminBloc, AdminState>(
      bloc: adminBloc,
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is AdminInitial) {
          adminBloc.add(LoadAnalyticsEvent());
        }
        if (state is AnalyticsDataLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AnalyticsDataLoadingSuccessState) {
          bottomTilesDates = state.weeklyFeedback.keys.toList();
          weeklyFeedbackNum = state.weeklyFeedback.values.toList();
          totalDocuments = state.totalDocuments;
          embeddedDocuments = state.embeddedDocuments;
          totalUsers = state.totalUsers;
          weeklyTotalQues = state.weeklyTotalQuestions;
          totalQues = state.totalQuestions;
          goodResponse = state.goodResponse;
          badResponse = state.badResponse;
        } else if (state is AnalyticsDataLoadingFailedState) {
          return AlertDialog(
            content:
                const Text('Not able to load data. Please try again later.'),
            actions: [
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Ok'))
            ],
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
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
                                leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        interval: max(2.0,
                                            (weeklyTotalQues / 10).toDouble()),
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
                                  bottom:
                                      BorderSide(color: Colors.black, width: 4),
                                  left: const BorderSide(
                                      color: Colors.black, width: 4),
                                  right: const BorderSide(
                                      color: Colors.transparent),
                                  top: const BorderSide(
                                      color: Colors.transparent),
                                ),
                              ),
                              gridData: const FlGridData(show: true),
                              barGroups: [
                                generateGroupData(
                                    0,
                                    weeklyFeedbackNum[0][0],
                                    weeklyFeedbackNum[0][2],
                                    weeklyFeedbackNum[0][1]),
                                generateGroupData(
                                    1,
                                    weeklyFeedbackNum[1][0],
                                    weeklyFeedbackNum[1][2],
                                    weeklyFeedbackNum[1][1]),
                                generateGroupData(
                                    2,
                                    weeklyFeedbackNum[2][0],
                                    weeklyFeedbackNum[2][2],
                                    weeklyFeedbackNum[2][1]),
                                generateGroupData(
                                    3,
                                    weeklyFeedbackNum[3][0],
                                    weeklyFeedbackNum[3][2],
                                    weeklyFeedbackNum[3][1]),
                                generateGroupData(
                                    4,
                                    weeklyFeedbackNum[4][0],
                                    weeklyFeedbackNum[4][2],
                                    weeklyFeedbackNum[4][1]),
                                generateGroupData(
                                    5,
                                    weeklyFeedbackNum[5][0],
                                    weeklyFeedbackNum[5][2],
                                    weeklyFeedbackNum[5][1]),
                                generateGroupData(
                                    6,
                                    weeklyFeedbackNum[6][0],
                                    weeklyFeedbackNum[6][2],
                                    weeklyFeedbackNum[6][1]),
                              ],
                            ),
                          ),
                        ),
                      ),
                      DataTable(columns: [
                        DataColumn(
                          label: Text("Total Quiries"),
                        ),
                        DataColumn(
                          label: Text(totalQues.toString()),
                        ),
                        DataColumn(
                          label: Text('100%'),
                        ),
                      ], rows: [
                        DataRow(cells: [
                          DataCell(
                            Text('Good Responses'),
                          ),
                          DataCell(
                            Text(goodResponse.toString()),
                          ),
                          DataCell(
                            Text(''),
                          ),
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Text('Bad Responses'),
                          ),
                          DataCell(
                            Text(badResponse.toString()),
                          ),
                          DataCell(
                            Text(''),
                          ),
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Text('No Responses'),
                          ),
                          DataCell(
                            Text((totalQues - goodResponse - badResponse)
                                .toString()),
                          ),
                          DataCell(
                            Text(''),
                          ),
                        ]),
                      ])
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width / 15,
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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
                              totalDocuments.toString(),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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
                              embeddedDocuments.toString(),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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
                              totalUsers.toString(),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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
                              weeklyTotalQues.toString(),
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
      },
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
