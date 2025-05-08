import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/features/budget/view/budget_screen.dart';
import 'package:personal_finance_tracker/features/transaction/view/transaction_history_screen.dart';

class AppRoutes {
  // Route name constants
  static const String dashboard = '/';
  static const String transactions = '/transactions';
  static const String transactionDetail = '/transactions/:id';
  static const String addTransaction = '/transactions/add';
  static const String login = '/login';
  static const String budget = '/budget';

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: budget,
    debugLogDiagnostics: true,
    routes: [
      /*GoRoute(
        path: dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),*/
      GoRoute(
        path: transactions,
        name: 'transactions',
        builder: (context, state) => const TransactionHistoryScreen(),
      ),
      /*GoRoute(
        path: transactionDetail,
        name: 'transactionDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TransactionDetailScreen(transactionId: id);
        },
      ),*/
      /*GoRoute(
        path: addTransaction,
        name: 'addTransaction',
        builder: (context, state) => const AddTransactionScreen(),
      ),*/
      /*GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),*/
      GoRoute(
        path: budget,
        name: 'budget',
        builder: (context, state) =>  BudgetScreen(),
      ),
    ],
    // Optional error handler for invalid routes
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(child: Text('Route not found: ${state.error}')),
        ),
  );

  // Navigation helper methods
  static void navigateTo(BuildContext context, String routeName) {
    context.goNamed(routeName);
  }

  static void navigateToTransactionDetail(BuildContext context, String id) {
    context.goNamed('transactionDetail', pathParameters: {'id': id});
  }

  static void navigateBack(BuildContext context) {
    context.pop();
  }
}
