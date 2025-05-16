import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/features/category/cubit/category_cubit.dart';
import 'package:personal_finance_tracker/shared/services/notification_service.dart';
import 'package:personal_finance_tracker/shared/utils/format_utils.dart';
import 'package:personal_finance_tracker/shared/widgets/transaction_tile.dart';

import '../../../config/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../cubit/transaction_cubit.dart';
import '../model/transaction_model.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late final TransactionCubit _transactionCubit;
  late final CategoryCubit _categoryCubit;
  final ScrollController _scrollController = ScrollController();

  int _pageSize = 7; // mặc định

  @override
  void initState() {
    super.initState();
    _transactionCubit = context.read<TransactionCubit>();
    _categoryCubit = context.read<CategoryCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final height = MediaQuery.of(context).size.height;
      final appBarHeight = Scaffold.of(context).appBarMaxHeight ?? 56;
      final paddingTop = MediaQuery.of(context).padding.top;
      final availableHeight = height - appBarHeight - paddingTop - 100;

      const itemHeight = 90; // ước lượng chiều cao mỗi item
      final itemsFit = (availableHeight / itemHeight).ceil();

      setState(() {
        _pageSize = itemsFit > 0 ? itemsFit : 7;
      });

      _transactionCubit.fetchInitialTransactionsWithLimit(_pageSize);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _transactionCubit.fetchMoreTransactions(_pageSize);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _editTransaction(BuildContext context, TransactionModel transaction) {
    context.go(AppRoutes.addTransaction, extra: transaction);
  }

  void _deleteTransaction(BuildContext context, TransactionModel transaction) async {
    bool confirm = await NotificationService.showConfirmDialog(
      context: context,
      title: 'Delete Transaction',
      content: "Are you sure you want to delete this transaction?",
      cancelText: 'Cancel',
      confirmText: 'Delete',
    );
    if (confirm && context.mounted) {
      await context.read<TransactionCubit>().deleteTransaction(transaction.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryVariant,
        ),
      ),
      body: BlocListener<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state is TransactionError) {
            NotificationService.showError(state.message);
          } else if (state is TransactionDeleted) {
            NotificationService.showSuccess('Transaction deleted successfully');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Today', style: TextStyle(fontSize: 16)),
              Expanded(
                child: BlocBuilder<TransactionCubit, TransactionState>(
                  builder: (context, state) {
                    if (state is TransactionLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TransactionLoaded) {
                      final transactions = state.transactions;
                      if (transactions.isEmpty) {
                        return const Center(
                          child: Text('No transactions found.'),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: state.hasMore
                            ? transactions.length + 1
                            : transactions.length,
                        itemBuilder: (context, index) {
                          if (index == transactions.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final transaction = transactions[index];
                          return Dismissible(
                            key: Key(transaction.id),
                            background: Container(
                              color: Colors.blue,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 16),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                _editTransaction(context, transaction);
                              } else if (direction ==
                                  DismissDirection.endToStart) {
                                _deleteTransaction(context, transaction);
                              }
                              return false;
                            },
                            child: TransactionTile(
                              iconLeading: _categoryCubit.getCategoryIcon(
                                transaction.category!.name,
                              ),
                              title: transaction.category!.name,
                              trailing: FormatUtils.formatCurrency(
                                transaction.amount,
                              ),
                              subTrailing: FormatUtils.formatDate(
                                transaction.transactionDate,
                              ),
                              iconLeadingStyle: IconThemeData(
                                size: 32,
                                color: _categoryCubit.getCategoryIconColor(
                                  transaction.category!.name,
                                ),
                              ),
                              titleStyle: const TextStyle(fontSize: 16),
                              trailingStyle: TextStyle(
                                fontSize: 16,
                                color:
                                transaction.category!.type.name == 'income'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              subTrailingStyle: const TextStyle(fontSize: 14),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
