import 'package:equatable/equatable.dart';
import 'package:personal_finance_tracker/features/transaction/model/transaction_model.dart';

enum DashboardStatus { initial, loading, loaded, error }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final List<TransactionModel> recentTransactions;
  final double totalIncome;
  final double totalExpenses;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.recentTransactions = const [],
    this.totalIncome = 0,
    this.totalExpenses = 0,
    this.errorMessage,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    List<TransactionModel>? recentTransactions,
    double? totalIncome,
    double? totalExpenses,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    recentTransactions,
    totalIncome,
    totalExpenses,
    errorMessage,
  ];
}
