import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:personal_finance_tracker/features/category/data/datasources/category_remote_datasource.dart';
import 'package:personal_finance_tracker/features/category/model/category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model/budget_model.dart';

@lazySingleton
class BudgetRemoteDataSource {
  final SupabaseClient _client;
  final CategoryRemoteDataSource _categoryRemoteDataSource;

  BudgetRemoteDataSource(
      this._client,
      this._categoryRemoteDataSource,
      );

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      return await _categoryRemoteDataSource.fetchCategories();
    } catch (e) {
      debugPrint('Error fetching categories: ${e.toString()}');
      throw Exception('Failed to fetch categories: ${e.toString()}');
    }
  }


  Future<void> saveBudget(BudgetModel budget) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final payload = {
        'user_id': userId,
        'amount': budget.amount,
        'category_id': budget.categoryId,
      };

      // Kiểm tra xem budget cho category này đã tồn tại chưa
      final existingBudget = await _client
          .from('budgets')
          .select()
          .eq('category_id', budget.categoryId)
          .eq('user_id', userId)
          .maybeSingle();

      dynamic response; // Khai báo kiểu rõ ràng
      if (existingBudget != null) {
        // Nếu đã tồn tại thì update
        response = await _client
            .from('budgets')
            .update(payload)
            .eq('category_id', budget.categoryId)
            .eq('user_id', userId)
            .select()
            .single();
        debugPrint('Budget updated successfully: $response');
      } else {
        // Nếu chưa tồn tại thì insert mới
        response = await _client
            .from('budgets')
            .insert(payload)
            .select()
            .single();
        debugPrint('Budget saved successfully: $response');
      }
    } catch (e) {
      debugPrint('Error saving budget: ${e.toString()}');
      throw Exception('Failed to save budget: ${e.toString()}');
    }
  }

  Future<BudgetModel?> getBudgetByCategory(String categoryId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('budgets')
          .select()
          .eq('category_id', categoryId)
          .eq('user_id', userId)
          .maybeSingle();

      return response != null ? BudgetModel.fromJson(response) : null;
    } catch (e) {
      debugPrint('Error fetching budget: ${e.toString()}');
      throw Exception('Failed to fetch budget: ${e.toString()}');
    }
  }
}