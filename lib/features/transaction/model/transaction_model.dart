import 'package:injectable/injectable.dart';

import '../../category/model/category_model.dart';



@injectable
class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final DateTime transactionDate;
  final String? note;
  final String? categoryId;
  final CategoryModel? category;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.transactionDate,
    this.note,
    this.categoryId,
    this.category,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(
    Map<String, dynamic> json, {
    CategoryModel? embeddedCategory,
  }) {
    // CategoryModel? category;
    // if (embeddedCategory != null) {
    //   category = embeddedCategory;
    // } else if (json['categories'] != null && json['categories'] is Map) {
    //   category = CategoryModel.fromJson(json['categories']);
    // } else if (json['category_name'] != null) {
    //   category = CategoryModel(
    //     id: json['categories']['id'] ?? '',
    //     name: json['categories']['name'] ?? '',
    //     type: CategoryModel.categoryTypeFromString(json['categories']['type']),
    //   );
    // }
    //
    // return TransactionModel(
    //   id: json['id'],
    //   userId: json['user_id'],
    //   amount: (json['amount'] as num).toDouble(),
    //   transactionDate: DateTime.parse(json['transaction_date']),
    //   note: json['note'],
    //   categoryId: json['category_id'],
    //   category: category,
    //   createdAt: DateTime.parse(json['created_at']),
    // );
    return TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      note: json['note'] as String?,
      categoryId: json['category_id'] as String?,
      category: embeddedCategory,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'amount': amount,
      'transaction_date': transactionDate.toIso8601String(),
      'note': note,
      'category_id': categoryId,
    };
  }
}
