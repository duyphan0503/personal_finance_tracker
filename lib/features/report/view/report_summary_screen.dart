import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../cubit/report_cubit.dart';

class ReportSummaryScreen extends StatefulWidget {
  const ReportSummaryScreen({super.key});

  @override
  State<ReportSummaryScreen> createState() => _ReportSummaryScreenState();
}

class _ReportSummaryScreenState extends State<ReportSummaryScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _loadData();
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
          return _buildSummaryContent(state.summaryData, _selectedMonth);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildSummaryContent(SummaryReportData data, DateTime selectedMonth) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );

    // Fake top expenses: bạn nên tính thực tế theo report_cubit
    final List<_ExpenseItem> topExpenses = [
      _ExpenseItem('Housing', 800, Icons.home),
      _ExpenseItem('Food', 450, Icons.restaurant),
      _ExpenseItem('Shopping', 300, Icons.shopping_bag),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          const Text(
            "Monthly Summary",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D1B3D),
            ),
          ),
          const SizedBox(height: 12),
          // Month
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD8A4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              DateFormat('MMMM yyyy').format(selectedMonth),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF003C5B),
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Balance
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
            currencyFormat.format(data.balance),
            style: const TextStyle(
              fontSize: 46,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D6B57),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 28),
          // Income & Expenses Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F3FF),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFFB7D6F7),
                      width: 1.4,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Income",
                        style: TextStyle(
                          color: Color(0xFF003C5B),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        currencyFormat.format(data.income),
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
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Color(0xFFFEDAAF), width: 1.4),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Expenses",
                        style: TextStyle(
                          color: Color(0xFFFF8800),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        currencyFormat.format(data.expense),
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
          const SizedBox(height: 32),
          // Top Expenses
          const Text(
            "Top Expenses",
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF0D1B3D),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          ...topExpenses.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  Icon(e.icon, color: const Color(0xFFFF8800), size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      e.name,
                      style: const TextStyle(
                        color: Color(0xFF0D1B3D),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    currencyFormat.format(e.amount),
                    style: const TextStyle(
                      color: Color(0xFF0D1B3D),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper for demo; in real use, map from category name or get from CategoryReportItem if you wish
class _ExpenseItem {
  final String name;
  final double amount;
  final IconData icon;
  _ExpenseItem(this.name, this.amount, this.icon);
}
