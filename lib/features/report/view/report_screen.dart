import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/features/report/cubit/report_cubit.dart';
import 'package:personal_finance_tracker/features/report/view/report_summary_screen.dart';
import 'package:personal_finance_tracker/shared/utils/format_utils.dart';

import '../../../config/theme/app_colors.dart';
import '../../../injection.dart';
import '../../../shared/widgets/summary_card.dart';
import 'category_report_screen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  late final ReportCubit _summaryCubit;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _summaryCubit =
        getIt<ReportCubit>()..loadReport(
          type: 'summary',
          filter: {'month': DateTime.now().month, 'year': DateTime.now().year},
        );

    _tabController = TabController(length: 3, vsync: this);
  }

  Widget _buildSummaryCards(ReportSummaryLoaded state) {
    final data = state.summaryData;
    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: 'INCOME',
            value: FormatUtils.formatCurrency(data.income, showDecimals: false),
            color: AppColors.incomeColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SummaryCard(
            title: 'EXPENSES',
            value: FormatUtils.formatCurrency(
              data.expense,
              showDecimals: false,
            ),
            color: AppColors.expenseColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SummaryCard(
            title: 'BALANCE',
            value: FormatUtils.formatCurrency(
              data.balance,
              showDecimals: false,
            ),
            color: AppColors.balanceColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      bloc: _summaryCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Financial Report'),
            centerTitle: true,
            titleTextStyle: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryVariant,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Summary cards or loader
                if (state is ReportLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state is ReportSummaryLoaded)
                  _buildSummaryCards(state)
                else
                  // fallback empty row to keep layout
                  Row(
                    children: const [
                      Expanded(child: SizedBox()),
                      SizedBox(width: 8),
                      Expanded(child: SizedBox()),
                      SizedBox(width: 8),
                      Expanded(child: SizedBox()),
                    ],
                  ),

                const SizedBox(height: 12),

                // Tab bar
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primaryVariant,
                  unselectedLabelColor: AppColors.orange,
                  indicatorColor: AppColors.primaryVariant,
                  tabs: const [
                    Tab(text: 'Monthly'),
                    Tab(text: 'Category'),
                    Tab(text: 'Summary'),
                  ],
                ),

                const SizedBox(height: 12),

                // Tab views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: const CategoryReportScreen(),
                      ),
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: const CategoryReportScreen(),
                      ),
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: const ReportSummaryScreen(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryButton,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Export as PDF",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryButton,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Send via Email",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 55),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
