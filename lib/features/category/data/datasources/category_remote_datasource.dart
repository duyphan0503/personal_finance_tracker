import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:personal_finance_tracker/features/category/model/category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class CategoryRemoteDataSource {
  final SupabaseClient _client;

  CategoryRemoteDataSource(SupabaseClient? client)
    : _client = client ?? Supabase.instance.client;

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final res = await _client
          .from('categories')
          .select()
          .order('name', ascending: true);

      return (res as List).map((data) => CategoryModel.fromJson(data)).toList();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      throw Exception('Failed to fetch categories: ${e.toString()}');
    }
  }

  IconData getCategoryIcon(String? categoryName) {
    switch (categoryName?.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'shopping':
        return Icons.shopping_bag;
      case 'housing':
        return Icons.home;
      case 'salary':
        return Icons.money_outlined;
      case 'freelance':
        return Icons.work;
      case 'investments':
        return Icons.trending_up;
      default:
        return Icons.category;
    }
  }

  Color getCategoryIconTheme(String? categoryName) {
    switch (categoryName?.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'shopping':
        return Colors.indigo;
      case 'housing':
        return Colors.orange;
      case 'salary':
        return Colors.teal;
      case 'freelance':
        return Colors.orange;
      case 'investments':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
}
