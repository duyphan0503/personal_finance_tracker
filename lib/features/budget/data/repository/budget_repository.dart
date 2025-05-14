import 'package:injectable/injectable.dart';
import 'package:personal_finance_tracker/features/category/data/datasources/category_remote_datasource.dart';
import '../../../category/model/category_model.dart';
import '../../model/budget_model.dart';
import '../datasources/budget_remote_datasource.dart';

@injectable
class BudgetRepository {
  final BudgetRemoteDataSource _remoteDataSource;
  final CategoryRemoteDataSource _categoryRemoteDataSource;

  BudgetRepository(this._remoteDataSource, this._categoryRemoteDataSource);

  // Lấy danh mục từ Supabase
  Future<List<CategoryModel>> fetchCategories() =>
      _categoryRemoteDataSource.fetchCategories();

  // Lưu ngân sách vào Supabase
  Future<void> saveBudget(BudgetModel budget) =>
      _remoteDataSource.saveBudget(budget);

  Future<BudgetModel?> getBudgetByCategory(String categoryId) =>
      _remoteDataSource.getBudgetByCategory(categoryId);
}
