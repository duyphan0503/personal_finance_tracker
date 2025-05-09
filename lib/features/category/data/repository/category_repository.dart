import 'package:injectable/injectable.dart';

import '../../model/category_model.dart';
import '../datasources/category_remote_datasource.dart';


@injectable
class CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepository(this._remoteDataSource);

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      return await _remoteDataSource.fetchCategories();
    } catch (e) {
      throw Exception('Failed to load categories: ${e.toString()}');
    }
  }
}