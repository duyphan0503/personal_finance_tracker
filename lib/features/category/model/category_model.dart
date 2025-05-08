import 'package:injectable/injectable.dart';

@injectable
class CategoryModel {
  final String id;
  final String name;
  final CategoryType type;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  // Chuyển đổi từ String sang enum
  static CategoryType typeFromString(String type) {
    switch (type) {
      case 'Income':
        return CategoryType.INCOME;
      case 'Expense':
        return CategoryType.EXPENSE;
      default:
        throw ArgumentError('Invalid category type: $type');
    }
  }

  // Chuyển enum sang String để lưu vào database
  static String typeToString(CategoryType type) {
    return type == CategoryType.INCOME ? 'Income' : 'Expense';
  }

  // Parse từ JSON sang object
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      type: typeFromString(json['type']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Chuyển object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': typeToString(type),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Enum loại danh mục
enum CategoryType {
  INCOME, // Thu nhập
  EXPENSE, // Chi tiêu
}
