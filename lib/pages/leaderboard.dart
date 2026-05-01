import 'package:asteron_x/service/getx/controller/leader_board_controller.dart';
import 'package:asteron_x/utils/theme.dart';
import 'package:asteron_x/widgets/x_loading.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  final LeaderBoardController leaderBoardController =
      Get.put(LeaderBoardController());

  @override
  void initState() {
    super.initState();
    // Update check is fired once at splash; no need to repeat per tab.
    leaderBoardController.fetchLeaderBoardData();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final s = context.semantics;

    return Obx(() {
      if (leaderBoardController.isLoading.value) {
        return const Center(child: CustomLoadingIndicator());
      }
      final data = leaderBoardController.leaderBoardData.value;
      if (data == null) {
        return Center(
          child: Text(
            'No data available',
            style:
                tt.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async => leaderBoardController.fetchLeaderBoardData(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _SectionLabel('Earnings'),
            const SizedBox(height: 12),
            _StatCard(
              title: 'This month',
              value: '₹${data.totalEarningsThisMonthDouble.toStringAsFixed(2)}',
              icon: Icons.trending_up_rounded,
              color: s.success,
              emphasis: true,
            ),
            const SizedBox(height: 12),
            _StatCard(
              title: 'Total earnings',
              value: '₹${data.totalEarningsDouble.toStringAsFixed(2)}',
              icon: Icons.account_balance_wallet_rounded,
              color: s.info,
            ),
            const SizedBox(height: 20),
            _ChartCard(
              title: 'Lead performance',
              child: SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: data.leadsSentThisMonthDouble.toDouble() + 20,
                    barTouchData: BarTouchData(enabled: true),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color:
                            scheme.outlineVariant.withValues(alpha: 0.4),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (v, _) => Text(
                            v.toInt().toString(),
                            style: tt.labelSmall?.copyWith(
                                color: scheme.onSurfaceVariant),
                          ),
                        ),
                      ),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (v, _) {
                            const labels = ['Sent', 'Closed', 'Failed'];
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                v.toInt() < labels.length
                                    ? labels[v.toInt()]
                                    : '',
                                style: tt.labelSmall,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      _bar(0, data.leadsSentThisMonthDouble.toDouble(),
                          s.warning),
                      _bar(1, data.leadsClosedSuccessfullyDouble.toDouble(),
                          s.success),
                      _bar(2, data.failedLeadsDouble.toDouble(),
                          scheme.error),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _SectionLabel('Lead breakdown'),
            const SizedBox(height: 12),
            _StatCard(
              title: 'Sent this month',
              value: data.leadsSentThisMonth?.toString() ?? '0',
              icon: Icons.send_rounded,
              color: s.warning,
            ),
            const SizedBox(height: 12),
            _StatCard(
              title: 'Total sent',
              value: data.totalLeadsSent?.toString() ?? '0',
              icon: Icons.outbox_rounded,
              color: scheme.primary,
            ),
            const SizedBox(height: 12),
            _StatCard(
              title: 'Closed successfully',
              value: data.leadsClosedSuccessfully?.toString() ?? '0',
              icon: Icons.check_circle_rounded,
              color: s.success,
            ),
            const SizedBox(height: 12),
            _StatCard(
              title: 'Failed',
              value: data.failedLeads?.toString() ?? '0',
              icon: Icons.cancel_rounded,
              color: scheme.error,
            ),
            const SizedBox(height: 20),
            _ChartCard(
              title: 'Distribution',
              child: SizedBox(
                height: 240,
                child: RadarChart(
                  RadarChartData(
                    dataSets: [
                      RadarDataSet(
                        dataEntries: [
                          RadarEntry(
                              value: data.totalEarningsThisMonthDouble),
                          RadarEntry(value: data.totalEarningsDouble),
                          RadarEntry(
                              value:
                                  data.leadsSentThisMonthDouble.toDouble()),
                          RadarEntry(
                              value: data.leadsClosedSuccessfullyDouble
                                  .toDouble()),
                          RadarEntry(value: data.failedLeadsDouble.toDouble()),
                        ],
                        fillColor: scheme.primary.withValues(alpha: 0.25),
                        borderColor: scheme.primary,
                      ),
                    ],
                    radarBorderData:
                        BorderSide(color: scheme.outlineVariant),
                    gridBorderData:
                        BorderSide(color: scheme.outlineVariant, width: 1),
                    tickBorderData: BorderSide(
                        color: scheme.outlineVariant
                            .withValues(alpha: 0.5)),
                    radarBackgroundColor: Colors.transparent,
                    titleTextStyle:
                        tt.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  BarChartGroupData _bar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 22,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool emphasis;
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.emphasis = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: emphasis
            ? color.withValues(alpha: 0.08)
            : scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: emphasis
              ? color.withValues(alpha: 0.3)
              : scheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: tt.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: tt.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800, color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _ChartCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
