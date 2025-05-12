import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/features/category/cubit/category_cubit.dart';
import 'package:personal_finance_tracker/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:personal_finance_tracker/features/dashboard/cubit/dashboard_state.dart';
import 'package:personal_finance_tracker/shared/utils/format_utils.dart';
import 'package:personal_finance_tracker/shared/widgets/summary_card.dart';

import '../../../injection.dart';
import '../../../shared/widgets/transactions/transaction_tile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardCubit _dashboardCubit;
  late final CategoryCubit _categoryCubit;

  @override
  void initState() {
    super.initState();
    _dashboardCubit = getIt<DashboardCubit>();
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
        final double totalAll = totalIncome + totalExpenses;
        final double incomePercent =
            totalAll <= 0 ? 50 : (totalIncome / totalAll) * 100;
        final double expensesPercent =
            totalAll <= 0 ? 50 : (totalExpenses / totalAll) * 100;

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
                      SummaryCard(
                        title: 'INCOME',
                        value: '$totalIncome',
                        color: Colors.greenAccent,
                      ),
                      SummaryCard(
                        title: 'EXPENSES',
                        value: '$totalExpenses',
                        color: Colors.orangeAccent,
                      ),
                      SummaryCard(
                        title: 'BALANCE',
                        value: '${_getBalance()}',
                        color: Colors.teal,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                color: Colors.greenAccent,
                                value:
                                    incomePercent.isFinite ? incomePercent : 50,
                                title: '',
                                radius: 30,
                              ),
                              PieChartSectionData(
                                color: Colors.orangeAccent,
                                value:
                                    expensesPercent.isFinite
                                        ? expensesPercent
                                        : 50,
                                title: '',
                                radius: 30,
                              ),
                              PieChartSectionData(
                                color: Colors.teal,
                                value: _getBalance(),
                                title: '',
                                radius: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 26),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LegendItem(color: Colors.teal, text: 'Income'),
                          const SizedBox(height: 10),
                          _LegendItem(
                            color: Colors.orangeAccent,
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
                            subTrailing:
                                state
                                            .recentTransactions[index]
                                            .category!
                                            .type
                                            .name ==
                                        'income'
                                    ? '+${state.recentTransactions[index].amount}'
                                    : '-${state.recentTransactions[index].amount}',
                            iconLeadingStyle: IconThemeData(
                              color: _categoryCubit.getCategoryIconColor(
                                state.recentTransactions[index].category!.name,
                              ),
                            ),
                          ),
                          if (index != state.recentTransactions.length - 1)
                            const Padding(
                              padding: EdgeInsets.only(left: 58),
                              child: Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0xFFE0E3E7),
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
          height: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
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
