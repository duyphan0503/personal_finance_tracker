import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../category/model/category_model.dart';
import '../data/repository/budget_repository.dart';
import '../model/budget_model.dart';

part 'budget_state.dart';

@injectable
class BudgetCubit extends Cubit<BudgetState> {
  final BudgetRepository _repository;

  BudgetCubit(this._repository) : super(BudgetInitial());

  Future<void> fetchCategories() async {
    try {
      emit(BudgetLoading());
      final categories = await _repository.fetchCategories();
      emit(BudgetLoaded(categories));
    } catch (e) {
      emit(BudgetError('Failed to load categories: ${e.toString()}'));
    }
  }

  Future<void> saveBudget(double amount, String categoryId) async {
    try {
      emit(BudgetSaving());
      final budget = BudgetModel(
        id: '', // ID sẽ được tạo tự động bởi Supabase
        categoryId: categoryId,
        amount: amount,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _repository.saveBudget(budget);
      emit(BudgetSaved());
    } catch (e) {
      emit(BudgetError('Failed to save budget: ${e.toString()}'));
    }
  }
}