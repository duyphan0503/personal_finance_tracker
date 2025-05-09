import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:personal_finance_tracker/features/category/cubit/category_state.dart';
import 'package:personal_finance_tracker/features/category/data/repository/category_repository.dart';

@injectable
class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _repository;

  CategoryCubit(this._repository) : super(CategoryInitial()) {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await _repository.fetchCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  IconData getCategoryIcon(String? categoryName) {
    return _repository.getCategoryIcon(categoryName);
  }

  Color getCategoryIconColor(String? categoryName) {
    return _repository.getCategoryIconColor(categoryName);
  }
}
