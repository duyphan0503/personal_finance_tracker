part of 'budget_cubit.dart';

abstract class BudgetState {}

class BudgetInitial extends BudgetState {}

class BudgetLoading extends BudgetState {}

class BudgetLoaded extends BudgetState {
  final List<CategoryModel> categories;

  BudgetLoaded(this.categories);
}

class BudgetSaving extends BudgetState {}

class BudgetSaved extends BudgetState {}

class BudgetError extends BudgetState {
  final String message;

  BudgetError(this.message);
}