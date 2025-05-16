import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/features/category/cubit/category_cubit.dart';
import 'package:personal_finance_tracker/features/category/model/category_model.dart';
import '../../../config/theme/app_colors.dart';
import '../cubit/category_state.dart';

class SelectCategoryScreen extends StatefulWidget {
  final CategoryModel? selectedCategory;

  const SelectCategoryScreen({
    super.key,
    this.selectedCategory,
  });

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    context.read<CategoryCubit>().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryVariant,
            )),
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CategoryError) {
            return Center(child: Text(state.message));
          }

          if (state is CategoryLoaded) {
            final expenseCategories = state.categories
                .where((c) => c.type == CategoryType.expense)
                .toList();
            final incomeCategories = state.categories
                .where((c) => c.type == CategoryType.income)
                .toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySection('EXPENSE', expenseCategories),
                  _buildCategorySection('INCOME', incomeCategories),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildCategorySection(String title, List<CategoryModel> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryItem(category);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryItem(CategoryModel category) {
    final isSelected = _selectedCategory?.id == category.id;
    final iconColor = context.read<CategoryCubit>().getCategoryIconColor(category.name);
    final iconData = context.read<CategoryCubit>().getCategoryIcon(category.name);

    return InkWell(
      onTap: () {
        context.pop(category);
      },
      onLongPress: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? iconColor.withAlpha(50) : Colors.white,
          border: isSelected
              ? Border.all(color: iconColor, width: 2)
              : Border.all(color: Colors.blue.shade50, width: 1),
        ),
        child: ListTile(
          leading: Icon(iconData, color: iconColor),
          title: Text(category.name,
              style: TextStyle(
                fontSize: 20,
                color: AppColors.primaryVariant,
              )),
        ),
      ),
    );
  }
}
