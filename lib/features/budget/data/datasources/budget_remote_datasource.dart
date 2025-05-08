import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../category/model/category_model.dart';
import '../../model/budget_model.dart';
@lazySingleton
class BudgetRemoteDataSource {
  final SupabaseClient _client;

  BudgetRemoteDataSource(this._client);

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await _client
          .from('categories')
          .select('*')
          .order('name', ascending: true);

      if (response.isEmpty) {
        throw Exception('No categories found');
      }

      return response.map<CategoryModel>((data) {
        try {
          return CategoryModel.fromJson(data);
        } catch (e) {
          throw Exception('Failed to parse category data: $e');
        }
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: ${e.toString()}');
    }
  }

  Future<void> saveBudget(BudgetModel budget) async {
    try {
      final payload = {
        'amount': budget.amount,
        'category_id': budget.categoryId,
        'created_at': budget.createdAt.toIso8601String(),
        'updated_at': budget.updatedAt.toIso8601String(),
      };

      final response = await _client.from('budgets').insert(payload).select().single();

      if (response == null) {
        throw Exception('Failed to save budget: No response from server');
      }
    } catch (e) {
      throw Exception('Failed to save budget: ${e.toString()}');
    }
  }
}