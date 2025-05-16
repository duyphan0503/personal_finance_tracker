import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/shared/services/notification_service.dart';
import '../../budget/view/budget_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _transactionReminderEnabled = true;
  bool _budgetLimitEnabled = false;
  bool _tipRecommendationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _transactionReminderEnabled = prefs.getBool('transactionReminder') ?? true;
      _budgetLimitEnabled = prefs.getBool('budgetLimit') ?? false;
      _tipRecommendationsEnabled = prefs.getBool('tipRecommendations') ?? true;
    });
  }

  void _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('transactionReminder', _transactionReminderEnabled);
    prefs.setBool('budgetLimit', _budgetLimitEnabled);
    prefs.setBool('tipRecommendations', _tipRecommendationsEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Notifications ',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          _buildNotificationItem(
            title: 'Transaction Reminder',
            description: 'Remind to add your expenses and incomes daily',
            value: _transactionReminderEnabled,
            onChanged: (value) {
              setState(() {
                _transactionReminderEnabled = value;
              });
              _saveSettings();
              NotificationService.showSuccess(
                  value
                      ? 'Transaction reminders enabled'
                      : 'Transaction reminders disabled');
            },
          ),
          const SizedBox(height: 16),

          _buildNotificationItem(
            title: 'Budget Limit',
            description: 'Notify when nearing your budget limit',
            value: _budgetLimitEnabled,
            onChanged: (value) async {
              if (value) {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BudgetScreen(),
                  ),
                );

                if (result == true) {
                  setState(() {
                    _budgetLimitEnabled = true;
                  });
                  _saveSettings();
                  NotificationService.showSuccess('Budget limit notifications enabled');
                } else {
                  setState(() {
                    _budgetLimitEnabled = false;
                  });
                }
              } else {
                setState(() {
                  _budgetLimitEnabled = false;
                });
                _saveSettings();
                NotificationService.showSuccess('Budget limit notifications disabled');
              }
            },
          ),
          const SizedBox(height: 16),

          _buildNotificationItem(
            title: 'Tip & Recommendations',
            description: 'Get helpful suggestions for managing your finances',
            value: _tipRecommendationsEnabled,
            onChanged: (value) {
              setState(() {
                _tipRecommendationsEnabled = value;
              });
              _saveSettings();
              NotificationService.showSuccess(
                  value
                      ? 'Tip & Recommendations enabled'
                      : 'Tip & Recommendations disabled');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFFFFFFF),
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.grey.shade300,
        activeTrackColor: const Color(0xFFFF8915).withOpacity(0.5),
      ),
    );
  }
}