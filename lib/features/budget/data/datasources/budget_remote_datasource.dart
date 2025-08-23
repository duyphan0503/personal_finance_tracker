import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:personal_finance_tracker/features/category/data/datasources/category_remote_datasource.dart';
import 'package:personal_finance_tracker/features/category/model/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/budget_model.dart';

@lazySingleton
class BudgetRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final CategoryRemoteDataSource _categoryRemoteDataSource;

  BudgetRemoteDataSource(
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    this._categoryRemoteDataSource,
  )   : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

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
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final payload = {
        'user_id': user.uid,
        'amount': budget.amount,
        'category_id': budget.categoryId,
        'updated_at': FieldValue.serverTimestamp(),
      };

      // Check if budget for this category already exists
      final existingBudget = await _firestore
          .collection('budgets')
          .where('category_id', isEqualTo: budget.categoryId)
          .where('user_id', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (existingBudget.docs.isNotEmpty) {
        // Update existing budget
        await _firestore
            .collection('budgets')
            .doc(existingBudget.docs.first.id)
            .update(payload);
        debugPrint('Budget updated successfully');
      } else {
        // Create new budget
        payload['created_at'] = FieldValue.serverTimestamp();
        await _firestore
            .collection('budgets')
            .add(payload);
        debugPrint('Budget created successfully');
      }
    } catch (e) {
      debugPrint('Error saving budget: ${e.toString()}');
      throw Exception('Failed to save budget: ${e.toString()}');
    }
  }

  Future<BudgetModel?> getBudgetByCategory(String categoryId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final querySnapshot = await _firestore
          .collection('budgets')
          .where('category_id', isEqualTo: categoryId)
          .where('user_id', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return BudgetModel.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
      }

      return null;
    } catch (e) {
      debugPrint('Error fetching budget: ${e.toString()}');
      throw Exception('Failed to fetch budget: ${e.toString()}');
    }
  }
}