import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/report_summary_cubit.dart';
import '../cubit/report_summary_state.dart';

class ReportSummaryScreen extends StatefulWidget {
  const ReportSummaryScreen({super.key});

  @override
  State<ReportSummaryScreen> createState() => _ReportSummaryScreenState();
}

class _ReportSummaryScreenState extends State<ReportSummaryScreen> {
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null && picked != _selectedMonth) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
      });
      _loadData();
    }
  }

  void _loadData() {
    context.read<ReportSummaryCubit>().loadSummary(_selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Monthly Summary',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _selectMonth(context),
        backgroundColor: const Color(0xFF003C5B),
        child: const Icon(Icons.calendar_today, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: BlocBuilder<ReportSummaryCubit, ReportSummaryState>(
          builder: (context, state) {
            if (state is ReportSummaryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReportSummaryError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is ReportSummaryLoaded) {
              return _buildSummaryContent(state);
            }
            return const Center(child: Text('Select a month to view summary'));
          },
        ),
      ),
    );
  }

  Widget _buildSummaryContent(ReportSummaryLoaded state) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month selector
          GestureDetector(
            onTap: () => _selectMonth(context),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD8A4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('MMMM yyyy').format(state.selectedMonth),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003C5B),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Color(0xFF003C5B)),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Balance section
          const Center(
            child: Text(
              'Balance',
              style: TextStyle(
                fontSize: 30,
                color: Color(0xFF131313),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              currencyFormat.format(state.balance),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: state.balance >= 0 ? Colors.black : Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Income & Expenses section
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF6FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFC2DBF6),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Income',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormat.format(state.income),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0DB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFEDAAF),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Expenses',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFFFF7C03),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormat.format(state.expenses),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF7C03),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Top Expenses section
          const Center(
            child: Text(
              'Top Expenses',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF050505),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (state.topExpenses.isNotEmpty)
            ...state.topExpenses.map((expense) {
              IconData categoryIcon;
              switch (expense.categoryName.toLowerCase()) {
                case 'housing':
                  categoryIcon = Icons.home;
                  break;
                case 'food':
                  categoryIcon = Icons.fastfood;
                  break;
                case 'shopping':
                  categoryIcon = Icons.shopping_cart;
                  break;
                default:
                  categoryIcon = Icons.category;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(categoryIcon, color: const Color(0xFFFF7C03)),
                        const SizedBox(width: 8),
                        Text(
                          expense.categoryName,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      currencyFormat.format(expense.amount),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF050505),
                      ),
                    ),
                  ],
                ),
              );
            }).toList()
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  'No expenses this month',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
