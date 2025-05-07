import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/shared/services/notification_service.dart';
import 'package:personal_finance_tracker/shared/widgets/transactions/transaction_tile.dart';

import '../cubit/transaction_cubit.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late final TransactionCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<TransactionCubit>();
    _cubit.fetchAllTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today'),
            const SizedBox(height: 8),
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
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return Dismissible(
                          key: Key(transaction.id),
                          background: Container(
                            color: Colors.blue,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 16),
                            child: const Icon(Icons.edit, color: Colors.white),
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
                            title: transaction.category!.name,
                          ),
                        );
                      },
                    );
                  } else if (state is TransactionError) {
                    NotificationService.showError(state.message);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editTransaction(BuildContext context, transaction) {}

  void _deleteTransaction(BuildContext context, transaction) async {
    bool confirm = await NotificationService.showConfirmDialog(
      context: context,
      title: 'Delete Transaction',
      content:
      "Are you sure you want to delete the transaction ${transaction
          .categoryId}",
      cancelText: 'Cancel',
      confirmText: 'Delete',
    );

    if (confirm && context.mounted) {
      context.read<TransactionCubit>().deleteTransaction(transaction.id);
      NotificationService.showSuccess(
        'Transaction deleted successfully',
      );
      return;
    }
  }
}
