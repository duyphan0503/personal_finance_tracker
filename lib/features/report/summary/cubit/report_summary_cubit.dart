import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:personal_finance_tracker/features/transaction/model/transaction_model.dart';
import '../../../category/model/category_model.dart';
import '../data/repository/report_summary_repository.dart';
import 'report_summary_state.dart';

@injectable
class ReportSummaryCubit extends Cubit<ReportSummaryState> {
  final ReportSummaryRepository _repository;

  ReportSummaryCubit(this._repository) : super(ReportSummaryInitial());

  Future<void> loadSummary(DateTime month) async {
    emit(ReportSummaryLoading());
    try {
      final transactions = await _repository.getMonthlyTransactions(month);

      // Debug logs
      debugPrint('Total transactions: ${transactions.length}');
      debugPrint('Income transactions: ${
          transactions.where((t) => t.category?.type == CategoryType.income).length
      }');
      debugPrint('Expense transactions: ${
          transactions.where((t) => t.category?.type == CategoryType.expense).length
      }');

      final income = _calculateIncome(transactions);
      final expenses = _calculateExpenses(transactions);
      final balance = income - expenses;
      final topExpenses = _getTopExpenses(transactions);

      debugPrint('Calculated income: $income');
      debugPrint('Calculated expenses: $expenses');
      debugPrint('Top expenses count: ${topExpenses.length}');

      emit(ReportSummaryLoaded(
        balance: balance,
        income: income,
        expenses: expenses,
        topExpenses: topExpenses,
        selectedMonth: month,
      ));
    } catch (e) {
      debugPrint('Error loading summary: $e');
      emit(ReportSummaryError(e.toString()));
    }
  }

  double _calculateIncome(List<TransactionModel> transactions) {
    return transactions
        .where((t) => t.category?.type == CategoryType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _calculateExpenses(List<TransactionModel> transactions) {
    return transactions
        .where((t) => t.category?.type == CategoryType.expense)
        .fold(0.0, (sum, t) => sum + t.amount.abs());
  }

  List<CategoryExpense> _getTopExpenses(List<TransactionModel> transactions) {
    final expenseMap = <String, double>{};

    for (final transaction in transactions.where((t) => t.category?.type == CategoryType.expense)) {
      final categoryName = transaction.category?.name ?? 'Uncategorized';
      expenseMap.update(
        categoryName,
            (value) => value + transaction.amount.abs(),
        ifAbsent: () => transaction.amount.abs(),
      );
    }

    final sortedExpenses = expenseMap.entries
        .map((e) => CategoryExpense(categoryName: e.key, amount: e.value))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return sortedExpenses.take(3).toList();
  }
}