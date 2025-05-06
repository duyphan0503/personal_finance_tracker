enum CategoryType { income, expense }

class CategoryModel {
  final String id;
  final String userId;
  final String name;
  final CategoryType type;

  CategoryModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      type: categoryTypeFromString(json['type'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'type': type.toString().split('.').last,
    };
  }

  static CategoryType categoryTypeFromString(String? typeStr) {
    if (typeStr == 'income') return CategoryType.income;
    if (typeStr == 'expense') return CategoryType.expense;
    return CategoryType.expense;
  }
}
