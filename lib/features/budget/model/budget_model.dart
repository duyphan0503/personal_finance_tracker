import 'package:injectable/injectable.dart';

import '../../category/model/category_model.dart';



@injectable
class BudgetModel {
  final String id;
  final String categoryId;
  final double amount;
  final CategoryModel? category;

  BudgetModel({
    required this.id,
    required this.categoryId,
    required this.amount,

    this.category,
  });

  // Factory constructor để tạo BudgetModel từ JSON
  factory BudgetModel.fromJson(
    Map<String, dynamic> json, {
    CategoryModel? embeddedCategory,
  }) {
    CategoryModel? category;

    // Kiểm tra và lấy danh mục từ JSON
    if (embeddedCategory != null) {
      category = embeddedCategory;
    } else if (json['category'] != null && json['category'] is Map) {
      category = CategoryModel.fromJson(json['category']);
    } else if (json['category_name'] != null) {
      category = CategoryModel(
        id: json['category']['id'] ?? '',
        name: json['category']['name'] ?? '',
        type: (json['category']['type']),
      );
    }

    return BudgetModel(
      id: json['id'],
      categoryId: json['category_id'],
      amount: (json['amount'] as num).toDouble(),

      category: category,
    );
  }

  // Phương thức chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {'category_id': categoryId, 'amount': amount};
  }
}
