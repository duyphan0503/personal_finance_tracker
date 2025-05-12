import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:personal_finance_tracker/features/transaction/data/repository/transaction_repository.dart';

import 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  final TransactionRepository _transactionRepository;

  DashboardCubit(this._transactionRepository) : super(const DashboardState());

  double get currentBalance {
    return state.totalIncome - state.totalExpenses;
  }

  Future<void> loadDashboardData() async {
    emit(state.copyWith(status: DashboardStatus.loading));

    try {
      final transactions = await _transactionRepository.fetchTransactions();

      // Calculate totals
      double income = 0;
      double expenses = 0;

      for (var transaction in transactions) {
        if (transaction.category!.type.name == 'income') {
          income += transaction.amount;
        } else {
          expenses += transaction.amount;
        }
      }

      final recentTransactions =
          [...transactions]
            ..sort((a, b) => b.transactionDate.compareTo(a.transactionDate))
            ..take(5).toList();

      emit(
        state.copyWith(
          status: DashboardStatus.loaded,
          recentTransactions: recentTransactions,
          totalIncome: income,
          totalExpenses: expenses,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DashboardStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
