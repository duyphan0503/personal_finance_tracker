import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model/category_model.dart';

@lazySingleton
class CategoryRemoteDataSource {
  final SupabaseClient _client;

  CategoryRemoteDataSource(SupabaseClient? client)
      : _client = client ?? Supabase.instance.client;

  // Lấy tất cả danh mục
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final res = await _client
          .from('categories')
          .select()
          .order('created_at', ascending: false);
      return res.map((data) => CategoryModel.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  // Lấy danh mục theo loại
  Future<List<CategoryModel>> fetchCategoriesByType(CategoryType type) async {
    try {
      final res = await _client
          .from('categories')
          .select()
          .eq('type', CategoryModel.typeToString(type))
          .order('name', ascending: true);
      return res.map((data) => CategoryModel.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories by type: $e');
    }
  }

  // Tạo danh mục mới
  Future<CategoryModel> createCategory({
    required String name,
    required CategoryType type,
  }) async {
    try {
      final payload = {
        'name': name,
        'type': CategoryModel.typeToString(type),
      };
      final res = await _client.from('categories').insert(payload).single();
      return CategoryModel.fromJson(res);
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }

  // Cập nhật danh mục
  Future<CategoryModel> updateCategory({
    required String id,
    String? name,
    CategoryType? type,
  }) async {
    try {
      final Map<String, dynamic> changes = {};
      if (name != null) changes['name'] = name;
      if (type != null) changes['type'] = CategoryModel.typeToString(type);

      final res = await _client
          .from('categories')
          .update(changes)
          .eq('id', id)
          .single();
      return CategoryModel.fromJson(res);
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  // Xóa danh mục
  Future<void> deleteCategory(String id) async {
    try {
      await _client.from('categories').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}