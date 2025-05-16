import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/features/category/cubit/category_cubit.dart';
import 'package:personal_finance_tracker/features/report/cubit/report_cubit.dart';
import 'package:personal_finance_tracker/injection.dart';

import '../../../shared/widgets/category_report_chart.dart';

class CategoryReportScreen extends StatefulWidget {
  const CategoryReportScreen({super.key});

  @override
  CategoryReportScreenState createState() => CategoryReportScreenState();
}

class CategoryReportScreenState extends State<CategoryReportScreen> {
  late final ReportCubit _reportCubit;
  late final CategoryCubit _categoryCubit;

  @override
  void initState() {
    super.initState();
    _reportCubit = getIt<ReportCubit>();
    _categoryCubit = getIt<CategoryCubit>();
    _reportCubit.loadReport(
      type: 'category',
      filter: {'month': DateTime.now().month, 'year': DateTime.now().year},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      bloc: _reportCubit,
      builder: (context, state) {
        if (state is ReportLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReportCategoryLoaded) {
          final expenseItems =
              state.categoryData.firstWhere((e) => e.title == 'Expense').items;
          final incomeItems =
              state.categoryData.firstWhere((e) => e.title == 'Income').items;

          List<PieChartSectionData> buildSections(
            List<CategoryReportPieItem> data,
          ) =>
              data.map((item) {
                final color = _categoryCubit.getCategoryIconColor(item.name);
                return PieChartSectionData(
                  color: color,
                  value: item.percent,
                  title: "${item.percent.toInt()}%",
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  radius: 70,
                  showTitle: true,
                );
              }).toList();

          List<LegendItem> buildLegends(List<CategoryReportPieItem> data) =>
              data.map((item) {
                final color = _categoryCubit.getCategoryIconColor(item.name);
                return LegendItem(label: item.name, color: color);
              }).toList();

          return CategoryReportChart(
            expenseSections: buildSections(expenseItems),
            expenseLegends: buildLegends(expenseItems),
            incomeSections: buildSections(incomeItems),
            incomeLegends: buildLegends(incomeItems),
          );
        } else if (state is ReportError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
