import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:personal_finance_tracker/features/report/data/repository/report_summary_repository.dart';
import 'package:personal_finance_tracker/features/transaction/model/transaction_model.dart';

import 'report_summary_state.dart';

@injectable
class ReportSummaryCubit extends Cubit<ReportSummaryState> {
  final ReportSummaryRepository _repository;

  ReportSummaryCubit(this._repository) : super(ReportSummaryInitial());

  Future<void> loadSummary(DateTime month) async {
    emit(ReportSummaryLoading());
    try {
      final transactions = await _repository.getMonthlyTransactions(month);

      final income = _calculateIncome(transactions);
      final expenses = _calculateExpenses(transactions);
      final balance = income - expenses;
      final topExpenses = _getTopExpenses(transactions);

      emit(ReportSummaryLoaded(
        balance: balance,
        income: income,
        expenses: expenses,
        topExpenses: topExpenses,
        selectedMonth: month,
      ));
    } catch (e) {
      emit(ReportSummaryError(e.toString()));
    }
  }

  double _calculateIncome(List<TransactionModel> transactions) {
    return transactions
        .where((t) => t.amount > 0)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _calculateExpenses(List<TransactionModel> transactions) {
    return transactions
        .where((t) => t.amount < 0)
        .fold(0.0, (sum, t) => sum + t.amount.abs());
  }

  List<CategoryExpense> _getTopExpenses(List<TransactionModel> transactions) {
    final expenseMap = <String, double>{};

    for (final transaction in transactions.where((t) => t.amount < 0)) {
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