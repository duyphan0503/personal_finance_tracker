part of 'category_cubit.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;

  CategoryLoaded(this.categories);
}

final class CategoryOperationSuccess extends CategoryState {
  final String message;

  CategoryOperationSuccess(this.message);
}

final class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}