import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/features/category/model/category_model.dart';

import '../../features/category/data/datasources/category_remote_datasource.dart';

class CategoryDropdown extends StatelessWidget {
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;
  final Function(CategoryModel?) onChanged;
  final CategoryRemoteDataSource dataSource;

  const CategoryDropdown({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
    required this.dataSource,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<CategoryModel>(
        isExpanded: true,
        value: selectedCategory,
        onChanged: onChanged,
        hint: const Text('Select Category'),
        items:
            categories.map((category) {
              return DropdownMenuItem<CategoryModel>(
                value: category,
                child: Row(
                  children: [
                    Icon(
                      dataSource.getCategoryIcon(category.name),
                      color: dataSource.getCategoryIconTheme(category.name),
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
