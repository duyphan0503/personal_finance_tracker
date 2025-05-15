import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/shared/utils/format_utils.dart';

import '../cubit/report_cubit.dart';

class MonthlyReportScreen extends StatefulWidget {
  const MonthlyReportScreen({super.key});

  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  int?
  _selectedIndex; // index của tháng đang chọn (0 = cũ nhất trong 7 tháng, 6 = mới nhất)

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    context.read<ReportCubit>().loadReport(
      type: 'monthly',
      filter:
          {}, // Không cần year, lấy toàn bộ transactions, _calculateMonthlyReport sẽ group lại
    );
  }

  double _calculateMaxY(List<double> values) {
    if (values.isEmpty) return 1000;
    double maxValue = values.reduce((a, b) => a > b ? a : b);
    if (maxValue == 0) return 1000;
    int steps = 5; // số mốc chia trục Y
    double interval = (maxValue / steps).ceilToDouble();
    double maxY = interval * steps;
    return maxY;
  }

  String formatMoney(double value) {
    if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(0)}M';
    if (value >= 10000) return '\$${(value / 1000).toStringAsFixed(0)}K';
    return '\$${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        if (state is ReportLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReportMonthlyLoaded) {
          final items =
              state.monthlyData; // Luôn có đúng 7 phần tử, từ cũ -> mới
          if (items.isEmpty) return const Center(child: Text('No data'));
          // Mặc định chọn tháng mới nhất (index 6)
          _selectedIndex ??= items.length - 1;
          // Danh sách index cho dropdown (cũ nhất đến mới nhất)

          final expenseList = items.map((e) => e.expense).toList();
          final incomeList = items.map((e) => e.income).toList();
          final monthLabels =
              items.map((e) => e.monthLabel.split(' ').first).toList();

          final selectedIncome = incomeList[_selectedIndex!];
          final selectedExpense = expenseList[_selectedIndex!];

          final double maxY = _calculateMaxY([...incomeList, ...expenseList]);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
            child: Column(
              children: [
                // Biểu đồ đường
                SizedBox(
                  height: 280,
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: maxY,
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 44,
                            getTitlesWidget: (value, meta) {
                              if (value % 1000 == 0) {
                                return Text(
                                  formatMoney(value),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF113C8D),
                                  ),
                                );
                              }
                              return Container();
                            },
                            /*interval: interval,*/
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              int idx = value.toInt();
                              if (idx >= 0 && idx < monthLabels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    monthLabels[idx],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF113C8D),
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                            interval: 1,
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          left: BorderSide(color: Color(0xFFE6E9F0)),
                          bottom: BorderSide(color: Color(0xFFE6E9F0)),
                          top: BorderSide.none,
                          right: BorderSide.none,
                        ),
                      ),
                      lineBarsData: [
                        // Expense (orange)
                        LineChartBarData(
                          isCurved: true,
                          color: const Color(0xFFFF8800),
                          barWidth: 3,
                          spots: [
                            for (int i = 0; i < expenseList.length; i++)
                              FlSpot(i.toDouble(), expenseList[i]),
                          ],
                          dotData: FlDotData(show: false),
                        ),
                        // Income (blue)
                        LineChartBarData(
                          isCurved: true,
                          color: const Color(0xFF0D6BCE),
                          barWidth: 3,
                          spots: [
                            for (int i = 0; i < incomeList.length; i++)
                              FlSpot(i.toDouble(), incomeList[i]),
                          ],
                          dotData: FlDotData(show: false),
                        ),
                      ],
                      lineTouchData: LineTouchData(enabled: false),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Chú thích
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Legend(color: const Color(0xFF0D6BCE), text: "Income"),
                    const SizedBox(width: 18),
                    _Legend(color: const Color(0xFFFF8800), text: "Expense"),
                  ],
                ),
                const SizedBox(height: 26),

                // Tổng thu chi tháng đã chọn (card)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9F3FF),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: const Color(0xFFB7D6F7),
                            width: 1.1,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Income",
                              style: TextStyle(
                                color: Color(0xFF003C5B),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              FormatUtils.formatCurrency(
                                selectedIncome,
                                showDecimals: false,
                              ),
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF003C5B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0DB),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: Color(0xFFFEDAAF),
                            width: 1.1,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Expense",
                              style: TextStyle(
                                color: Color(0xFFFF8800),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              FormatUtils.formatCurrency(
                                selectedExpense,
                                showDecimals: false,
                              ),
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF8800),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),

                // Dropdown chọn tháng
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDADADA)),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  width: double.infinity,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedIndex,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF113C8D),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF113C8D),
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                      items: [
                        for (int i = 0; i < items.length; i++)
                          DropdownMenuItem(
                            value: i,
                            child: Text(
                              items[i].monthLabel,
                              style: const TextStyle(color: Color(0xFF113C8D)),
                            ),
                          ),
                      ],
                      onChanged: (idx) {
                        if (idx != null) {
                          setState(() {
                            _selectedIndex = idx;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is ReportError) {
          return Center(child: Text("Error: ${state.message}"));
        }
        return const SizedBox();
      },
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;

  const _Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 5,
          color: color,
          margin: const EdgeInsets.only(right: 6),
        ),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}
