import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model/category_model.dart';

@lazySingleton
class CategoryRemoteDataSource {
  final SupabaseClient _client;

  CategoryRemoteDataSource(this._client);

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await _client
          .from('categories')
          .select()
          .order('name', ascending: true);

      if (response.isEmpty) {
        throw Exception('No categories found in database');
      }

      return response.map<CategoryModel>((data) {
        try {
          return CategoryModel.fromJson(data);
        } catch (e) {
          throw FormatException('Failed to parse category: $e\nData: $data');
        }
      }).toList();
    } on FormatException catch (e) {
      throw Exception('Data format error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch categories: ${e.toString()}');
    }
  }

  Future<CategoryModel> createCategory({
    required String name,
    required CategoryType type,
  }) async {
    try {
      final payload = {
        'name': name,
        'type': CategoryModel.typeToString(type),
      };
      final response = await _client.from('categories').insert(payload).select().single();
      return CategoryModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create category: ${e.toString()}');
    }
  }

  Future<CategoryModel> updateCategory({
    required String id,
    String? name,
    CategoryType? type,
  }) async {
    try {
      final Map<String, dynamic> changes = {};
      if (name != null) changes['name'] = name;
      if (type != null) changes['type'] = CategoryModel.typeToString(type);

      final response = await _client
          .from('categories')
          .update(changes)
          .eq('id', id)
          .select()
          .single();
      return CategoryModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update category: ${e.toString()}');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _client.from('categories').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete category: ${e.toString()}');
    }
  }
}