import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/config/theme/app_colors.dart';
import 'package:personal_finance_tracker/features/category/cubit/category_cubit.dart';
import 'package:personal_finance_tracker/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:personal_finance_tracker/features/dashboard/cubit/dashboard_state.dart';
import 'package:personal_finance_tracker/shared/utils/format_utils.dart';
import 'package:personal_finance_tracker/shared/widgets/summary_card.dart';

import '../../../injection.dart';
import '../../../shared/widgets/transaction_tile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final CategoryCubit _categoryCubit;

  @override
  void initState() {
    super.initState();
    _categoryCubit = getIt<CategoryCubit>();
    context.read<DashboardCubit>().loadDashboardData();
  }

  double _getBalance() {
    return context.read<DashboardCubit>().currentBalance;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state.status == DashboardStatus.loading &&
            state.recentTransactions.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final double totalIncome = state.totalIncome;
        final double totalExpenses = state.totalExpenses;
        final double totalAll = totalIncome + totalExpenses + _getBalance();
        final double incomePercent =
            totalAll == 0 ? 0 : (totalIncome / totalAll) * 100;
        final double expensesPercent =
            totalAll == 0 ? 0 : (totalExpenses / totalAll) * 100;
        final double balancePercent =
            totalAll == 0 ? 0 : (_getBalance() / totalAll) * 100;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 20),
                      child: Text(
                        'Dashboard',
                        style:
                            Theme.of(
                              context,
                            ).textTheme.displayMedium?.copyWith(),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'INCOME',
                          value: FormatUtils.formatCurrency(
                            totalIncome,
                            showDecimals: false,
                          ),
                          color: AppColors.incomeColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SummaryCard(
                          title: 'EXPENSES',
                          value: FormatUtils.formatCurrency(
                            totalExpenses,
                            showDecimals: false,
                          ),
                          color: AppColors.expenseColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SummaryCard(
                          title: 'BALANCE',
                          value: FormatUtils.formatCurrency(
                            _getBalance(),
                            showDecimals: false,
                          ),
                          color: AppColors.balanceColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 46,
                            startDegreeOffset: -90,
                            sections: [
                              PieChartSectionData(
                                color: AppColors.incomeColor,
                                value:
                                    incomePercent.isFinite ? incomePercent : 50,
                                title: '',
                                radius: 35,
                              ),
                              PieChartSectionData(
                                color: AppColors.expenseColor,
                                value:
                                    expensesPercent.isFinite
                                        ? expensesPercent
                                        : 50,
                                title: '',
                                radius: 35,
                              ),
                              PieChartSectionData(
                                color: AppColors.balanceColor,
                                value: balancePercent,
                                title: '',
                                radius: 35,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 26),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LegendItem(
                            color: AppColors.incomeColor,
                            text: 'Income',
                          ),
                          const SizedBox(height: 10),
                          _LegendItem(
                            color: AppColors.expenseColor,
                            text: 'Expenses',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 34),
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (state.recentTransactions.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('No recent transactions'),
                      ),
                    )
                  else
                    ...List.generate(
                      state.recentTransactions.length,
                      (index) => Column(
                        children: [
                          TransactionTile(
                            iconLeading: _categoryCubit.getCategoryIcon(
                              state.recentTransactions[index].category!.name,
                            ),
                            title:
                                state.recentTransactions[index].category!.name,
                            subtitle: FormatUtils.formatDateContextual(
                              state.recentTransactions[index].transactionDate,
                            ),
                            trailing: FormatUtils.formatCurrency(
                              state.recentTransactions[index].amount,
                              showDecimals: false,
                            ),
                            margin: EdgeInsets.zero,
                            showBorder: false,
                            iconLeadingStyle: IconThemeData(
                              color: _categoryCubit.getCategoryIconColor(
                                state.recentTransactions[index].category!.name,
                              ),
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 17,
          height: 35,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
