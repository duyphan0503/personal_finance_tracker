import 'package:equatable/equatable.dart';

abstract class ReportSummaryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReportSummaryInitial extends ReportSummaryState {}

class ReportSummaryLoading extends ReportSummaryState {}

class ReportSummaryLoaded extends ReportSummaryState {
  final double balance;
  final double income;
  final double expenses;
  final List<CategoryExpense> topExpenses;
  final DateTime selectedMonth;

  ReportSummaryLoaded({
    required this.balance,
    required this.income,
    required this.expenses,
    required this.topExpenses,
    required this.selectedMonth,
  });

  @override
  List<Object?> get props => [
    balance,
    income,
    expenses,
    topExpenses,
    selectedMonth,
  ];
}

class ReportSummaryError extends ReportSummaryState {
  final String message;

  ReportSummaryError(this.message);

  @override
  List<Object?> get props => [message];
}

class CategoryExpense extends Equatable {
  final String categoryName;
  final double amount;

  const CategoryExpense({
    required this.categoryName,
    required this.amount,
  });

  @override
  List<Object?> get props => [categoryName, amount];
}