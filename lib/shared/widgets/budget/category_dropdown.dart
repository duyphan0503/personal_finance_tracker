import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/features/category/model/category_model.dart';

class CategoryDropdown extends StatelessWidget {
  final List<CategoryModel> categories; // Thay vì List<String>, dùng List<CategoryModel>
  final CategoryModel? selectedCategory;
  final Function(CategoryModel?) onChanged;

  const CategoryDropdown({
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<CategoryModel>(
      value: selectedCategory,
      onChanged: onChanged,
      items: categories.map((category) {
        return DropdownMenuItem<CategoryModel>(
          value: category,
          child: Text(category.name), // Hiển thị tên danh mục
        );
      }).toList(),
    );
  }
}
