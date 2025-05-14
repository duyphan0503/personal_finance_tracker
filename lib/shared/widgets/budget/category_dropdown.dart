import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/features/category/model/category_model.dart';

class CategoryDropdown extends StatelessWidget {
  final List<CategoryModel> categories; // Thay vì List<String>, dùng List<CategoryModel>
  final CategoryModel? selectedCategory;
  final Function(CategoryModel?) onChanged;
  final IconData categoryIcon;
  final Color iconColor;

  const CategoryDropdown({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
    required this.categoryIcon,
    required this.iconColor
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Chiếm toàn bộ chiều ngang
      padding: const EdgeInsets.symmetric(horizontal: 12), // Thêm padding nếu cần
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<CategoryModel>(
        isExpanded: true, // Quan trọng: giúp dropdown mở rộng theo container
        value: selectedCategory,
        onChanged: onChanged,
        items: categories.map((category) {
          return DropdownMenuItem<CategoryModel>(
            value: category,
            child: Row(
              children: [
                Icon(
                  categoryIcon,
                  color: iconColor,
                ),
                const SizedBox(width: 8),
                Text(category.name),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
