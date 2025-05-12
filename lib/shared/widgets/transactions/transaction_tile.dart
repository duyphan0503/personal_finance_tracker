import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final IconData? iconLeading;
  final String title;
  final String? subtitle;
  final String? trailing;
  final String? subTrailing;

  final IconThemeData? iconLeadingStyle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? trailingStyle;
  final TextStyle? subTrailingStyle;

  const TransactionTile({
    super.key,
    this.iconLeading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.subTrailing,
    this.iconLeadingStyle,
    this.titleStyle,
    this.subtitleStyle,
    this.trailingStyle,
    this.subTrailingStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(width: 1, color: Colors.grey.shade300),
      ),
      color: Colors.white,
      child: ListTile(
        leading:
            iconLeading != null
                ? Icon(
                  iconLeading,
                  size: iconLeadingStyle?.size,
                  color:
                      iconLeadingStyle?.color ??
                      Theme.of(context).iconTheme.color,
                )
                : null,
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            title,
            style:
                titleStyle ??
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Text(
          subtitle ?? '',
          style:
              subtitleStyle ??
              const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              trailing ?? '',
              style:
                  trailingStyle ??
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (subTrailing != null)
              Text(
                subTrailing!,
                style:
                    subTrailingStyle ??
                    const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
