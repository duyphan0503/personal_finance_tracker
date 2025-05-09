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

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final catJson = json['categories'] as Map<String, dynamic>?;
    final CategoryModel? category =
    catJson != null ? CategoryModel.fromJson(catJson) : null;

    return TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      note: json['note'] as String?,
      categoryId: json['category_id'] as String?,
      category: category,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'user_id': userId,
      'amount': amount,
      'transaction_date': transactionDate.toIso8601String(),
    };

    if (note != null && note!.isNotEmpty) {
      data['note'] = note;
    }
    if (categoryId != null && categoryId!.isNotEmpty) {
      data['category_id'] = categoryId;
    }

    return data;
  }
}
