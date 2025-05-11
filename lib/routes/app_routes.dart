import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/features/auth/view/sign_in_screen.dart';
import 'package:personal_finance_tracker/features/report/summary/view/report_summary_screen.dart';
import 'package:personal_finance_tracker/features/transaction/view/transaction_history_screen.dart';

import '../features/dashboard/view/dashboard_screen.dart';

class AppRoutes {
  // Route name constants
  static const String signIn = '/signIn';
  static const String dashboard = '/dashboard';
  static const String transactionsHistory = '/transactionsHistory';
  static const String transactionDetail = '/transactions/:id';
  static const String addTransaction = '/transactions/add';
  static const String report = '/report';
  static const String settings = '/settings';
  static const String reportSummaryScreen = '/report_summary_screen';
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.reportSummaryScreen,
    routes: [
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithBottomNav(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.addTransaction,
            builder: (context, state) => const Placeholder(),
          ),
          GoRoute(
            path: AppRoutes.transactionsHistory,
            builder: (context, state) => const TransactionHistoryScreen(),
          ),
          GoRoute(
            path: AppRoutes.reportSummaryScreen,
            builder: (context, state) => const ReportSummaryScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const Placeholder(),
          ),

        ],
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(child: Text('Route not found: ${state.error}')),
        ),
  );
}

class ScaffoldWithBottomNav extends StatelessWidget {
  final Widget child;

  const ScaffoldWithBottomNav({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.dashboard)) return 0;
    if (location.startsWith(AppRoutes.addTransaction)) return 1;
    if (location.startsWith(AppRoutes.transactionsHistory)) return 2;
    if (location.startsWith(AppRoutes.reportSummaryScreen)) return 3;
    if (location.startsWith(AppRoutes.settings)) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.dashboard);
        break;
      case 1:
        context.go(AppRoutes.addTransaction);
        break;
      case 2:
        context.go(AppRoutes.transactionsHistory);
        break;
      case 3:
        context.go(AppRoutes.reportSummaryScreen);
        break;
      case 4:
        context.go(AppRoutes.settings);
        break;
    }
  }
}
