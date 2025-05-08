import 'package:injectable/injectable.dart';

import '../../../category/model/category_model.dart';
import '../../model/budget_model.dart';
import '../datasources/budget_remote_datasource.dart';


@injectable
class BudgetRepository {
  final BudgetRemoteDataSource _remoteDataSource;

  BudgetRepository(this._remoteDataSource);

  // Lấy danh mục từ Supabase
  Future<List<CategoryModel>> fetchCategories() => _remoteDataSource.fetchCategories();

  // Lưu ngân sách vào Supabase
  Future<void> saveBudget(BudgetModel budget) => _remoteDataSource.saveBudget(budget);
}
