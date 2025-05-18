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

  // Dialog to set budget
  void _showSetBudgetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'No budgets set',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'You haven\'t set a budget for any\ncategories. Would you like to set\none now?',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          setState(() {
                            _budgetLimitEnabled = false; // Keep switch off if canceled
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8915),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BudgetScreen(),
                            ),
                          ).then((result) {
                            if (result == true) {
                              // If result is 'true', enable the switch
                              setState(() {
                                _budgetLimitEnabled = true;
                              });
                              _saveSettings();
                              NotificationService.showSuccess('Budget limit notifications enabled');
                            } else {
                              // If result is 'false', keep switch off
                              setState(() {
                                _budgetLimitEnabled = false;
                              });
                            }
                          });
                        },
                        child: const Text(
                          'Set Budget',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
                // Show dialog when trying to enable
                _showSetBudgetDialog();
              } else {
                // Directly disable if turning off
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