import 'package:asteron_x/service/getx/controller/UpdateController.dart';
import 'package:asteron_x/service/getx/controller/leader_board_controller.dart';
import 'package:asteron_x/service/models/leaderboard_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:asteron_x/utils/colors.dart';
import 'package:get/get.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  final LeaderBoardController leaderBoardController =
      Get.put(LeaderBoardController());
  UpdateController updatecontroller = Get.put(UpdateController());

  @override
  void initState() {
    super.initState();
    updatecontroller.checkLatestVersion();
    leaderBoardController.fetchLeaderBoardData();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      child: SafeArea(
        child: Obx(
          () {
            if (leaderBoardController.isLoading.value) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            final data = leaderBoardController.leaderBoardData.value;

            if (data == null) {
              return const Center(
                child: Text(
                  'No data available',
                  style: TextStyle(fontSize: 18, color: CupertinoColors.label),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Earnings Title
                  const Text(
                    "Earnings Overview",
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: greyColor,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Earned This Month
                  _buildLeaderboardSection(
                    title: 'Earned This Month',
                    value:
                        '₹ ${data.totalEarningsThisMonthDouble.toStringAsFixed(2)}',
                    color: successColor,
                    icon: CupertinoIcons.money_dollar_circle_fill,
                  ),
                  SizedBox(height: 16),

                  // CupertinoButton(
                  //     child: Text('check update'),
                  //     onPressed: () {
                  //       updatecontroller.checkLatestVersion();
                  //     }),

                  SizedBox(height: 16),

                  // Total Earnings
                  _buildLeaderboardSection(
                    title: 'Total Earnings',
                    value: '₹ ${data.totalEarningsDouble.toStringAsFixed(2)}',
                    color: Colors.blue,
                    icon: CupertinoIcons.money_dollar_circle,
                  ),
                  SizedBox(height: 16),

                  // Bar Chart
                  _buildBarChart(data),
                  SizedBox(height: 32),

                  // Leads Title
                  const Text(
                    "Leads Performance",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.label,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Leads Sent This Month
                  _buildLeaderboardSection(
                    title: 'Leads Sent This Month',
                    value: data.leadsSentThisMonth?.toString() ?? '0',
                    color: Colors.orange,
                    icon: CupertinoIcons.mail_solid,
                  ),
                  SizedBox(height: 16),

                  // Total Leads Sent
                  _buildLeaderboardSection(
                    title: 'Total Leads Sent',
                    value: data.totalLeadsSent?.toString() ?? '0',
                    color: Colors.purple,
                    icon: CupertinoIcons.mail,
                  ),
                  SizedBox(height: 16),

                  // Leads Closed Successfully
                  _buildLeaderboardSection(
                    title: 'Leads Closed Successfully',
                    value: data.leadsClosedSuccessfully?.toString() ?? '0',
                    color: Colors.green,
                    icon: CupertinoIcons.checkmark_seal_fill,
                  ),
                  SizedBox(height: 16),

                  // Failed Leads
                  _buildLeaderboardSection(
                    title: 'Failed Leads',
                    value: data.failedLeads?.toString() ?? '0',
                    color: Colors.red,
                    icon: CupertinoIcons.xmark_seal_fill,
                  ),
                  SizedBox(height: 16),

                  // Pie Chart
                  _buildRadarChart(data),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLeaderboardSection({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGroupedBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.label,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarChart(LeaderBoardModel data) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGroupedBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: RadarChart(
        RadarChartData(
          dataSets: [
            RadarDataSet(
              dataEntries: [
                RadarEntry(value: data.totalEarningsThisMonthDouble),
                RadarEntry(value: data.totalEarningsDouble),
                RadarEntry(value: (data.leadsSentThisMonthDouble).toDouble()),
                RadarEntry(
                    value: (data.leadsClosedSuccessfullyDouble).toDouble()),
                RadarEntry(value: (data.failedLeadsDouble).toDouble()),
              ],
              fillColor: Colors.blue.withOpacity(0.3),
              borderColor: Colors.blue,
            ),
          ],
          radarBorderData: BorderSide(color: Colors.grey),
          radarBackgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildBarChart(LeaderBoardModel data) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGroupedBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (data.leadsSentThisMonthDouble.toDouble()) + 20,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.label,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text('Leads Sent');
                    case 1:
                      return const Text('Closed');
                    case 2:
                      return const Text('Failed');
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                    toY: (data.leadsSentThisMonthDouble).toDouble(),
                    color: Colors.orange),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                    toY: (data.leadsClosedSuccessfullyDouble).toDouble(),
                    color: Colors.green),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                    toY: (data.failedLeadsDouble).toDouble(),
                    color: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
