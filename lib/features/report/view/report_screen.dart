import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/features/report/cubit/report_cubit.dart';
import 'package:personal_finance_tracker/features/report/view/monthly_report_screen.dart';
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

                // Custom TabBar (redesigned to match image 2)
                _ReportCustomTabBar(
                  controller: _tabController,
                  tabs: const ['Monthly', 'Category', 'Summary'],
                ),

                const SizedBox(height: 12),

                // Tab views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: const MonthlyReportScreen(),
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

class _ReportCustomTabBar extends StatefulWidget {
  final TabController controller;
  final List<String> tabs;

  const _ReportCustomTabBar({required this.controller, required this.tabs});

  @override
  State<_ReportCustomTabBar> createState() => _ReportCustomTabBarState();
}

class _ReportCustomTabBarState extends State<_ReportCustomTabBar> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.controller.index;
    widget.controller.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_selectedTab != widget.controller.index) {
      setState(() {
        _selectedTab = widget.controller.index;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: List.generate(widget.tabs.length, (i) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                widget.controller.animateTo(i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease,
                margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    widget.tabs[i],
                    style: TextStyle(
                      color: const Color(0xFF11214A),
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
