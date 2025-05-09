import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../data/datasources/category_remote_datasource.dart';
import '../model/category_model.dart';

part 'category_state.dart';

@injectable
class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryCubit(this._remoteDataSource) : super(CategoryInitial());

  Future<void> fetchCategories() async {
    try {
      emit(CategoryLoading());
      final categories = await _remoteDataSource.fetchCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError('Failed to load categories: ${e.toString()}'));
    }
  }

  Future<void> createCategory({
    required String name,
    required CategoryType type,
  }) async {
    try {
      emit(CategoryLoading());
      await _remoteDataSource.createCategory(name: name, type: type);
      emit(CategoryOperationSuccess('Category created successfully'));
      await fetchCategories();
    } catch (e) {
      emit(CategoryError('Failed to create category: ${e.toString()}'));
    }
  }

  Future<void> updateCategory({
    required String id,
    String? name,
    CategoryType? type,
  }) async {
    try {
      emit(CategoryLoading());
      await _remoteDataSource.updateCategory(id: id, name: name, type: type);
      emit(CategoryOperationSuccess('Category updated successfully'));
      await fetchCategories();
    } catch (e) {
      emit(CategoryError('Failed to update category: ${e.toString()}'));
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      emit(CategoryLoading());
      await _remoteDataSource.deleteCategory(id);
      emit(CategoryOperationSuccess('Category deleted successfully'));
      await fetchCategories();
    } catch (e) {
      emit(CategoryError('Failed to delete category: ${e.toString()}'));
    }
  }
}