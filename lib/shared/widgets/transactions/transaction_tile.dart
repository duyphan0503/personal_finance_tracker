import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final IconData? iconLeading;
  final String title;
  final String? subtitle;
  final String? trailing;
  final String? subTrailing;

  const TransactionTile({
    super.key,
    this.iconLeading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.subTrailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(iconLeading),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle ?? '',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              trailing ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (subTrailing != null)
              Text(
                subTrailing!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
