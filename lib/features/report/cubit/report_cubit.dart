import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../category/model/category_model.dart';
import '../../transaction/model/transaction_model.dart';
import '../data/repository/report_repository.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepository _repository;

  ReportCubit(this._repository) : super(ReportInitial());

  Future<void> loadReport({
    required String type, // 'category', 'monthly', 'summary'
    required Map<String, dynamic> filter,
  }) async {
    emit(ReportLoading());
    try {
      // Load dữ liệu transactions từ remote, có thể filter theo tháng/năm/category
      final transactions = await _repository.fetchTransactions(filter: filter);

      // Tính toán dữ liệu cần thiết cho từng loại report
      switch (type) {
        case 'category':
          final categoryData = _calculateCategoryReport(transactions, filter);
          emit(ReportCategoryLoaded(categoryData: categoryData));
          break;
        case 'monthly':
          final monthlyData = _calculateMonthlyReport(transactions, filter);
          emit(ReportMonthlyLoaded(monthlyData: monthlyData));
          break;
        case 'summary':
          final summaryData = _calculateSummaryReport(transactions, filter);
          emit(ReportSummaryLoaded(summaryData: summaryData));
          break;
        default:
          emit(const ReportError('Unknown report type'));
      }
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  // Group by category, sum amount
  List<CategoryReportItem> _calculateCategoryReport(
    List<TransactionModel> transactions,
    Map<String, dynamic> filter,
  ) {
    final Map<String, double> expenseMap = {};
    final Map<String, double> incomeMap = {};

    for (final t in transactions) {
      final cName = t.category?.name ?? 'Uncategorized';
      final categoryType = t.category?.type ?? CategoryType.expense;

      if (categoryType == CategoryType.expense) {
        expenseMap.update(
          cName,
          (v) => v + t.amount.abs(),
          ifAbsent: () => t.amount.abs(),
        );
      } else {
        incomeMap.update(cName, (v) => v + t.amount, ifAbsent: () => t.amount);
      }
    }

    final totalExpense = expenseMap.values.fold(0.0, (sum, e) => sum + e);
    final totalIncome = incomeMap.values.fold(0.0, (sum, e) => sum + e);

    return [
      CategoryReportItem(
        title: 'Expense',
        total: totalExpense,
        items:
            expenseMap.entries
                .map(
                  (e) => CategoryReportPieItem(
                    name: e.key,
                    value: e.value,
                    percent:
                        totalExpense == 0 ? 0 : e.value / totalExpense * 100,
                    type: 'expense',
                  ),
                )
                .toList(),
      ),
      CategoryReportItem(
        title: 'Income',
        total: totalIncome,
        items:
            incomeMap.entries
                .map(
                  (e) => CategoryReportPieItem(
                    name: e.key,
                    value: e.value,
                    percent: totalIncome == 0 ? 0 : e.value / totalIncome * 100,
                    type: 'income',
                  ),
                )
                .toList(),
      ),
    ];
  }

  // Group by month
  List<MonthlyReportItem> _calculateMonthlyReport(
    List<TransactionModel> transactions,
    Map<String, dynamic> filter,
  ) {
    // Tạo map {year: {month: {income, expense}}}
    final Map<int, Map<int, double>> incomeMap = {};
    final Map<int, Map<int, double>> expenseMap = {};

    for (final t in transactions) {
      final date = t.transactionDate;
      final year = date.year;
      final month = date.month;
      incomeMap.putIfAbsent(year, () => {for (int m = 1; m <= 12; m++) m: 0});
      expenseMap.putIfAbsent(year, () => {for (int m = 1; m <= 12; m++) m: 0});
      if (t.category?.type == CategoryType.expense) {
        expenseMap[year]![month] =
            (expenseMap[year]![month] ?? 0) + t.amount.abs();
      } else {
        incomeMap[year]![month] = (incomeMap[year]![month] ?? 0) + t.amount;
      }
    }

    // Lấy 7 tháng gần nhất bất kể năm
    final now = DateTime.now();
    List<DateTime> last7Months = List.generate(7, (i) {
      final dt = DateTime(now.year, now.month - (6 - i));
      return DateTime(dt.year, dt.month);
    });

    final List<String> allMonthLabels = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    final List<MonthlyReportItem> monthlyData = [];
    for (final dt in last7Months) {
      final year = dt.year;
      final month = dt.month;
      final label = '${allMonthLabels[month - 1]} $year';
      final income = incomeMap[year]?[month] ?? 0;
      final expense = expenseMap[year]?[month] ?? 0;
      monthlyData.add(
        MonthlyReportItem(monthLabel: label, income: income, expense: expense),
      );
    }
    return monthlyData;
  }

  // Tổng hợp lại balance, tổng thu, tổng chi
  SummaryReportData _calculateSummaryReport(
    List<TransactionModel> transactions,
    Map<String, dynamic> filter,
  ) {
    double income = 0, expense = 0;
    for (final t in transactions) {
      if (t.category!.type.name == 'expense') {
        expense += t.amount.abs();
      } else {
        income += t.amount;
      }
    }
    return SummaryReportData(
      balance: income - expense,
      income: income,
      expense: expense,
    );
  }
}
