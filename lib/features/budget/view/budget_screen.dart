import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/features/category/cubit/category_cubit.dart';
import 'package:personal_finance_tracker/injection.dart';
import 'package:personal_finance_tracker/shared/services/notification_service.dart';
import 'package:personal_finance_tracker/shared/widgets/budget/category_dropdown.dart';
import '../../category/data/datasources/category_remote_datasource.dart';
import '../../category/model/category_model.dart';
import '../cubit/budget_cubit.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController _budgetController = TextEditingController();
  CategoryModel? _selectedCategory;
  late final CategoryCubit _categoryCubit;
  double? _currentBudgetAmount;

  @override
  void initState() {
    super.initState();
    _categoryCubit = getIt<CategoryCubit>();
    _budgetController.addListener(_updateBudgetDisplay);
    context.read<BudgetCubit>().fetchCategories();
    _categoryCubit.fetchCategories();
  }

  @override
  void dispose() {
    _budgetController.removeListener(_updateBudgetDisplay);
    _budgetController.dispose();
    super.dispose();
  }

  void _updateBudgetDisplay() => setState(() {});

  Future<void> _onCategoryChanged(CategoryModel? category) async {
    setState(() {
      _selectedCategory = category;
      _currentBudgetAmount = null;
    });

    if (category != null) {
      final budget = await context.read<BudgetCubit>().getBudgetByCategory(category.id);
      if (budget != null && mounted) {
        setState(() {
          _currentBudgetAmount = budget.amount;
          _budgetController.text = _formatCurrencyInputForDisplay(budget.amount.toString());
        });
      } else if (mounted) {
        setState(() {
          _budgetController.clear();
        });
      }
    }
  }

  String _formatCurrency(String value) {
    final number = double.tryParse(value.replaceAll(',', '')) ?? 0;
    return number.toStringAsFixed(number.truncateToDouble() == number ? 0 : 2)
        .replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }

  String _formatCurrencyInputForDisplay(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleanValue.isEmpty) return '';

    final number = double.tryParse(cleanValue) ?? 0;
    return number.toStringAsFixed(number.truncateToDouble() == number ? 0 : 2)
        .replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }

  void _formatCurrencyInput(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleanValue.isEmpty) {
      _budgetController.text = '';
      return;
    }

    final dots = cleanValue.split('.').length - 1;
    final sanitizedValue = dots > 1
        ? cleanValue.replaceFirst('.', '').replaceAll('.', '')
        : cleanValue;

    final parts = sanitizedValue.split('.');
    final integerPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );

    final formatted = parts.length > 1
        ? '$integerPart.${parts[1]}'
        : integerPart;

    if (formatted != _budgetController.text) {
      _budgetController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

// In the _saveBudget method, replace the existing implementation with:
  void _saveBudget() {
    if (_selectedCategory == null) {
      NotificationService.showError('Please select a category');
      return;
    }

    final cleanAmount = _budgetController.text.replaceAll(',', '');
    final amount = double.tryParse(cleanAmount);

    if (amount == null || amount <= 0) {
      NotificationService.showError('Please enter a valid amount');
      return;
    }

    context.read<BudgetCubit>().saveBudget(amount, _selectedCategory!.id)
        .then((_) {
      NotificationService.showSuccess('Budget saved successfully!');
      Navigator.pop(context, false); // Pass 'false' to reset the Budget Limit
    })
        .catchError((e) {
      NotificationService.showError('Failed to save budget: $e');
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Set Budget',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocConsumer<BudgetCubit, BudgetState>(
        listener: (context, state) {
          if (state is BudgetError) {
            NotificationService.showError(state.message);
          } else if (state is BudgetSaved) {
            NotificationService.showSuccess('Budget saved successfully!');
            _budgetController.clear();
            setState(() => _selectedCategory = null);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    _currentBudgetAmount != null
                        ? '\$${_formatCurrency(_currentBudgetAmount!.toString())}'
                        : '\$${_budgetController.text.isEmpty ? '0' : _formatCurrency(_budgetController.text)}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                const Text(
                  'Budget Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                if (state is BudgetLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state is BudgetLoaded)
                  state.categories.isEmpty
                      ? const Text(
                    'No categories available',
                    style: TextStyle(color: Colors.red),
                  )
                      : CategoryDropdown(
                    categories: state.categories,
                    onChanged: _onCategoryChanged,
                    selectedCategory: _selectedCategory,
                    dataSource: getIt<CategoryRemoteDataSource>(),
                  )
                else if (state is BudgetError)
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                const SizedBox(height: 24),

                const Text(
                  'Monthly Budget',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '\$',
                    hintText: '2,500',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  onChanged: (value) => _formatCurrencyInput(value),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state is BudgetSaving ? null : _saveBudget,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B00),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: state is BudgetSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}