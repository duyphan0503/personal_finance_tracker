import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:personal_finance_tracker/features/category/data/datasources/category_remote_datasource.dart';

import '../../model/category_model.dart';

@lazySingleton
class CategoryRepository {
  CategoryRemoteDataSource categoryRemoteDataSource;

  CategoryRepository(this.categoryRemoteDataSource);

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      return await categoryRemoteDataSource.fetchCategories();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  IconData getCategoryIcon(String? categoryName) {
    return categoryRemoteDataSource.getCategoryIcon(categoryName);
  }

  Color getCategoryIconColor(String? categoryName) {
    return categoryRemoteDataSource.getCategoryIconTheme(categoryName);
  }
}
