part of 'budget_cubit.dart';

abstract class BudgetState {
  const BudgetState();
}

class BudgetInitial extends BudgetState {
  const BudgetInitial();
}

class BudgetLoading extends BudgetState {
  const BudgetLoading();
}

class BudgetLoaded extends BudgetState {
  final List<CategoryModel> categories;

  const BudgetLoaded(this.categories);
}

class BudgetEmpty extends BudgetState {
  const BudgetEmpty();
}

class BudgetSaving extends BudgetState {
  const BudgetSaving();
}

class BudgetSaved extends BudgetState {
  const BudgetSaved();
}

class BudgetError extends BudgetState {
  final String message;

  const BudgetError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BudgetError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}