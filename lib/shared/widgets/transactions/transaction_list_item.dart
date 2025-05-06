import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/shared/widgets/transactions/transaction_tile.dart';

class TransactionListItem extends StatelessWidget {
  final String id;
  final String title;
  final String? subtitle;
  final String amount;
  final String date;
  final IconData icon;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TransactionListItem({
    super.key,
    required this.id,
    required this.title,
    this.subtitle,
    required this.amount,
    required this.date,
    required this.icon,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id),
      background: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Edit action
          onEdit();
          return false; // Don't dismiss the item
        } else {
          // Delete action - show confirmation dialog
          final bool? result = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm'),
                content: const Text(
                  'Are you sure you want to delete this transaction?',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Delete'),
                  ),
                ],
              );
            },
          );
          if (result == true) {
            onDelete();
          }
          return result;
        }
      },
      child: TransactionTile(
        iconLeading: icon,
        title: title,
        subtitle: subtitle,
        trailing: amount,
        subTrailing: date,
      ),
    );
  }
}