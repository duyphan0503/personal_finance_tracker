import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_tracker/features/category/cubit/category_cubit.dart';
import 'package:personal_finance_tracker/features/category/model/category_model.dart';
import 'package:personal_finance_tracker/features/transaction/cubit/transaction_cubit.dart';
import 'package:personal_finance_tracker/injection.dart';
import 'package:personal_finance_tracker/routes/app_routes.dart';
import 'package:personal_finance_tracker/shared/services/notification_service.dart';
import 'package:personal_finance_tracker/shared/utils/format_utils.dart';

import '../../category/cubit/category_state.dart';

const _navyColor = Color(0xFF0A2E60);
const _orangeColor = Color(0xFFFFA726);
const _lightBackground = Color(0xFFF4F6F8);

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late final CategoryCubit _categoryCubit;
  late final TransactionCubit _transactionCubit;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  CategoryModel? _selectedCategory;
  String _selectedCategoryName = 'Housing';
  IconData _selectedCategoryIcon = Icons.home;
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _categoryCubit = getIt<CategoryCubit>();
    _transactionCubit = getIt<TransactionCubit>();
    _initializeDefaultCategory();
  }

  Future<void> _initializeDefaultCategory() async {
    await _categoryCubit.fetchCategories();
    final state = _categoryCubit.state;
    if (state is CategoryLoaded) {
      final matched = state.categories.where(
        (c) => c.name.toLowerCase() == _selectedCategoryName.toLowerCase(),
      );
      _selectedCategory =
          matched.isNotEmpty ? matched.first : state.categories.first;
      _selectedCategoryName = _selectedCategory!.name;
      _selectedCategoryIcon = _categoryCubit.getCategoryIcon(
        _selectedCategoryName,
      );
      setState(() {});
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: _orangeColor,
                onPrimary: Colors.white,
                onSurface: _navyColor,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectCategory() async {
    final result = await context.push<CategoryModel>(AppRoutes.selectCategory);
    if (result != null) {
      setState(() {
        _selectedCategory = result;
        _selectedCategoryName = result.name;
        _selectedCategoryIcon = _categoryCubit.getCategoryIcon(result.name);
      });
    }
  }

  void _onAmountChanged(String value) {
    String cleaned = value.replaceAll('\$', '').replaceAll(',', '').trim();
    if (cleaned.isEmpty) {
      _amountController.text = '';
      _amountController.selection = const TextSelection.collapsed(offset: 0);
      return;
    }
    double? val = double.tryParse(cleaned);
    if (val != null && val >= 0) {
      final formatted = NumberFormat("#,##0.00", "en_US").format(val);
      final newText = '\$$formatted';
      _amountController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  }

  Future<void> _submit() async {
    if (_selectedCategory == null) {
      NotificationService.showError('Please select a category');
      return;
    }
    String input =
        _amountController.text.replaceAll('\$', '').replaceAll(',', '').trim();
    if (input.isEmpty) {
      NotificationService.showError('Please enter an amount');
      return;
    }
    double? amount = double.tryParse(input);
    if (amount == null || amount <= 0) {
      NotificationService.showError('Invalid amount');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await _transactionCubit.addTransaction(
        categoryId: _selectedCategory!.id,
        amount: amount,
        note: _noteController.text.trim(),
        date: _selectedDate,
      );
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        NotificationService.showError('Error: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryCubit.getCategoryIconColor(
      _selectedCategoryName,
    );

    return Scaffold(
      backgroundColor: _lightBackground,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: _navyColor),
        backgroundColor: _lightBackground,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Add Transaction',
                style: TextStyle(
                  color: _navyColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 32),
              // Amount input
              _AmountInput(
                controller: _amountController,
                onChanged: _onAmountChanged,
              ),
              const SizedBox(height: 28),
              const _SectionLabel(text: 'Note'),
              const SizedBox(height: 7),
              TextField(
                controller: _noteController,
                style: const TextStyle(fontSize: 16, color: _navyColor),
                decoration: InputDecoration(
                  hintText: 'Write a note',
                  hintStyle: TextStyle(color: _navyColor.withOpacity(0.35)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(color: _navyColor.withOpacity(0.12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(color: _navyColor.withOpacity(0.12)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(color: _orangeColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const _SectionLabel(text: 'Category'),
              const SizedBox(height: 7),
              GestureDetector(
                onTap: _selectCategory,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.08),
                    border: Border.all(color: categoryColor, width: 2),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _selectedCategoryIcon,
                        color: categoryColor,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _selectedCategoryName,
                        style: const TextStyle(
                          color: _navyColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right, color: _navyColor),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const _SectionLabel(text: 'Date'),
              const SizedBox(height: 7),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: _navyColor.withOpacity(0.12)),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Row(
                    children: [
                      Text(
                        FormatUtils.formatDateSimple(_selectedDate),
                        style: const TextStyle(
                          color: _navyColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right, color: _navyColor),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _orangeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isSubmitting ? null : _submit,
                  child:
                      _isSubmitting
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.8,
                            ),
                          )
                          : const Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 26),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: _navyColor.withOpacity(0.7),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AmountInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;

  const _AmountInput({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: _navyColor,
        fontWeight: FontWeight.bold,
        fontSize: 44,
        letterSpacing: -2,
      ),
      decoration: const InputDecoration(
        hintText: '\$0.00',
        hintStyle: TextStyle(
          color: Color(0xFFB0B3B8),
          fontWeight: FontWeight.bold,
          fontSize: 44,
          letterSpacing: -2,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
        filled: true,
        fillColor: Colors.transparent,
      ),
      onChanged: onChanged,
    );
  }
}
