import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/config/theme/app_theme.dart';
import 'package:personal_finance_tracker/features/auth/cubit/auth_cubit.dart';
import 'package:personal_finance_tracker/features/category/cubit/category_cubit.dart';
import 'package:personal_finance_tracker/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:personal_finance_tracker/features/transaction/cubit/transaction_cubit.dart';
import 'package:personal_finance_tracker/injection.dart';
import 'package:personal_finance_tracker/routes/app_routes.dart';

import 'features/report/summary/cubit/report_summary_cubit.dart';

class PersonalFinanceTrackerApp extends StatefulWidget {
  const PersonalFinanceTrackerApp({super.key});

  @override
  State<PersonalFinanceTrackerApp> createState() =>
      _PersonalFinanceTrackerAppState();
}

class _PersonalFinanceTrackerAppState extends State<PersonalFinanceTrackerApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TransactionCubit>(
          create: (_) => getIt<TransactionCubit>(),
        ),
        BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
        BlocProvider<CategoryCubit>(create: (_) => getIt<CategoryCubit>()),
        BlocProvider<DashboardCubit>(create: (_) => getIt<DashboardCubit>()),
        BlocProvider<ReportSummaryCubit>(create: (_) => getIt<ReportSummaryCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Personal Finance Tracker',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
