import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/config/theme/app_colors.dart';

class CategoryReportChart extends StatelessWidget {
  final List<PieChartSectionData> expenseSections;
  final List<LegendItem> expenseLegends;

  final List<PieChartSectionData> incomeSections;
  final List<LegendItem> incomeLegends;

  const CategoryReportChart({
    super.key,
    required this.expenseSections,
    required this.expenseLegends,
    required this.incomeSections,
    required this.incomeLegends,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Expenses by Category",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryVariant,
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Expense",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D68A0),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 170,
                height: 170,
                child: PieChart(
                  PieChartData(
                    sections: expenseSections,
                    sectionsSpace: 0,
                    centerSpaceRadius: 0,
                    startDegreeOffset: -90,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      expenseLegends
                          .map(
                            (e) => _LegendRow(label: e.label, color: e.color),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            "Income",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D68A0),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 170,
                height: 170,
                child: PieChart(
                  PieChartData(
                    sections: incomeSections,
                    sectionsSpace: 0,
                    centerSpaceRadius: 0,
                    startDegreeOffset: -90,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      incomeLegends
                          .map(
                            (e) => _LegendRow(label: e.label, color: e.color),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LegendItem {
  final String label;
  final Color color;

  const LegendItem({required this.label, required this.color});
}

class _LegendRow extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendRow({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF11224D),
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
