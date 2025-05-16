import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_tracker/features/category/cubit/category_cubit.dart';
import 'package:personal_finance_tracker/injection.dart';

import '../../../config/theme/app_colors.dart';
import '../cubit/report_cubit.dart';

class ReportSummaryScreen extends StatefulWidget {
  const ReportSummaryScreen({super.key});

  @override
  State<ReportSummaryScreen> createState() => _ReportSummaryScreenState();
}

class _ReportSummaryScreenState extends State<ReportSummaryScreen> {
  late final CategoryCubit _categoryCubit;
  late DateTime _selectedMonth;
  final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _loadData();
    _categoryCubit = getIt<CategoryCubit>();
  }

  void _loadData() {
    context.read<ReportCubit>().loadReport(
      type: 'summary',
      filter: {'month': _selectedMonth.month, 'year': _selectedMonth.year},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        if (state is ReportLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReportError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is ReportSummaryLoaded) {
          return _buildSummaryContent(
            state.summaryData,
            _getTopExpenses(state.categoryData),
          );
        }
        return const SizedBox();
      },
    );
  }

  List<_ExpenseItem> _getTopExpenses(List<CategoryReportItem> categoryData) {
    try {
      final expenseCategory = categoryData.firstWhere(
            (item) => item.title == 'Expense',
        orElse: () => const CategoryReportItem(
          title: 'Expense',
          total: 0,
          items: [],
        ),
      );

      // Group items by name and sum their values
      final expenseMap = <String, double>{};
      for (final item in expenseCategory.items) {
        expenseMap.update(
          item.name,
              (value) => value + item.value,
          ifAbsent: () => item.value,
        );
      }

      // Convert to list and sort by value descending
      final sortedEntries = expenseMap.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      // Take top 3 and map to _ExpenseItem
      return sortedEntries.take(3).map((entry) => _ExpenseItem(
        entry.key,
        entry.value,
        _categoryCubit.getCategoryIcon(entry.key),
      )).toList();
    } catch (e) {
      return [];
    }
  }

  Widget _buildSummaryContent(
      SummaryReportData data,
      List<_ExpenseItem> topExpenses,
      ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildBalanceSection(data),
          const SizedBox(height: 28),
          _buildIncomeExpenseCards(data),
          const SizedBox(height: 32),
          _buildTopExpensesSection(topExpenses),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          "Monthly Summary",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D1B3D),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD8A4),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            DateFormat('MMMM yyyy').format(_selectedMonth),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF003C5B),
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceSection(SummaryReportData data) {
    return Column(
      children: [
        const Text(
          "Balance",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D1B3D),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          _currencyFormat.format(data.balance),
          style: TextStyle(
            fontSize: 46,
            fontWeight: FontWeight.bold,
            color: data.balance >= 0 ? const Color(0xFF0D6B57) : Colors.red,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeExpenseCards(SummaryReportData data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCard(
          title: "Income",
          amount: data.income,
          color: const Color(0xFFE9F3FF),
          borderColor: const Color(0xFFB7D6F7),
          textColor: const Color(0xFF003C5B),
        ),
        const SizedBox(width: 16),
        _buildCard(
          title: "Expenses",
          amount: data.expense,
          color: const Color(0xFFFFF0DB),
          borderColor: const Color(0xFFFEDAAF),
          textColor: const Color(0xFFFF8800),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required double amount,
    required Color color,
    required Color borderColor,
    required Color textColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: 1.4),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _currencyFormat.format(amount),
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopExpensesSection(List<_ExpenseItem> topExpenses) {
    return Column(
      children: [
        const Text(
          "Top Expenses",
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF0D1B3D),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),
        if (topExpenses.isEmpty)
          const Text(
            "No expenses this month",
            style: TextStyle(
              color: Color(0xFF0D1B3D),
              fontSize: 16,
            ),
          )
        else
          ...topExpenses.map((e) => _buildExpenseItem(e)),
      ],
    );
  }

  Widget _buildExpenseItem(_ExpenseItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(item.icon, color: _categoryCubit.getCategoryIconColor(item.name), size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              item.name,
              style: TextStyle(
                color: AppColors.primaryVariant,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            _currencyFormat.format(item.amount),
            style: TextStyle(
              color: AppColors.primaryVariant,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseItem {
  final String name;
  final double amount;
  final IconData icon;

  _ExpenseItem(this.name, this.amount, this.icon);
}
