import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/features/report/cubit/report_cubit.dart';

import '../../../config/theme/app_colors.dart';

class MonthlyReportScreen extends StatefulWidget {
  final ReportCubit cubit;
  const MonthlyReportScreen({Key? key, required this.cubit}) : super(key: key);

  @override
  _MonthlyReportScreenState createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      bloc: widget.cubit,
      builder: (context, state) {
        if (state is ReportLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReportMonthlyLoaded) {
          final data = state.monthlyData;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = data[index];
              return ListTile(
                title: Text(
                  item.monthLabel,
                  style: const TextStyle(color: AppColors.primaryVariant),
                ),
                subtitle: Text(
                  'Income: \$${item.income.toStringAsFixed(2)}, Expense: \$${item.expense.toStringAsFixed(2)}',
                ),
              );
            },
          );
        } else if (state is ReportError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
