import 'package:flutter/material.dart';

class BudgetView extends StatefulWidget {
  @override
  _BudgetViewState createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> {
  final TextEditingController _budgetController = TextEditingController(text: '2,500');
  bool _housingSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Set Budget',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(height: 12),
              Text('\$2,500',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(height: 32),

              // Budget Category - Modified Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Budget Category',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87)),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.home,
                            size: 20,
                            color: Colors.orange),
                        SizedBox(width: 8),
                        Text('Housing',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Monthly Budget
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Monthly Budget',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87)),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: '\$',
                  hintText: '2,500',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
              SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}