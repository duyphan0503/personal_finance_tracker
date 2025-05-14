import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_tracker/features/report/cubit/report_summary_cubit.dart';
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
            color: Color(0xFF003C5B), // Màu xanh đậm
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
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
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month title
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Thêm padding để có không gian cho khung
            decoration: BoxDecoration(
              color: const Color(0xFFFFD8A4), // Màu khung ngày tháng
              borderRadius: BorderRadius.circular(8), // Tùy chọn bo góc khung
            ),
            child: Text(
              DateFormat('MMMM yyyy').format(state.selectedMonth),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003C5B), // Màu chữ xanh đậm
                height: 1.5,
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
              fontSize: 16,
              color: Color(0xFF003C5B), // Màu xanh đậm
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            currencyFormat.format(state.balance),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003C5B), // Màu xanh đậm
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Income & Expenses section
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Income Section with Blue Background
            Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 45),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF6FF), // Màu xanh nhạt cho Income
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFC2DBF6), // Màu viền
                  width: 2, // Độ dày của viền (có thể điều chỉnh)
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Income',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(state.income),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
            // Expenses Section with Orange Background
            Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0DB), // Màu cam nhạt cho Expenses
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFFEDAAF), // Màu viền
                  width: 2, // Độ dày của viền (có thể điều chỉnh)
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Expenses',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFF7C03), // Màu chữ cam cho Expenses
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(state.expenses),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF7C03), // Màu chữ cam cho Expenses
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Top Expenses section
        const SizedBox(height: 16),
        Center( // Centered the title
          child: const Text(
            'Top Expenses',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003C5B), // Màu xanh đậm cho tiêu đề
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...state.topExpenses.map((expense) {
          // Xử lý việc thêm biểu tượng cho các danh mục cụ thể
          IconData? categoryIcon;
          switch (expense.categoryName.toLowerCase()) {
            case 'housing':
              categoryIcon = Icons.home; // Biểu tượng nhà
              break;
            case 'food':
              categoryIcon = Icons.fastfood; // Biểu tượng thức ăn
              break;
            case 'shopping':
              categoryIcon = Icons.shopping_cart; // Biểu tượng giỏ hàng
              break;
            default:
              categoryIcon = Icons.category; // Biểu tượng mặc định
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  categoryIcon, // Sử dụng icon tương ứng
                  color: Color(0xFFFF7C03), // Màu của biểu tượng
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    expense.categoryName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                ),
                Text(
                  currencyFormat.format(expense.amount),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003C5B), // Màu xanh đậm cho giá trị
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
