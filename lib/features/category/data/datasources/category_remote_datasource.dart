import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:personal_finance_tracker/features/category/model/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@lazySingleton
class CategoryRemoteDataSource {
  final FirebaseFirestore _firestore;

  CategoryRemoteDataSource(FirebaseFirestore? firestore)
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection('categories')
          .orderBy('name')
          .get();

      return querySnapshot.docs
          .map((doc) => CategoryModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
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
        return Icons.people;
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
        return Colors.indigo;
    }
  }
}
