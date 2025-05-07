import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/features/transaction/cubit/transaction_cubit.dart';
import 'package:personal_finance_tracker/injection.dart';
import 'package:personal_finance_tracker/routes/app_routes.dart';

class PersonalFinanceTrackerApp extends StatefulWidget {
  const PersonalFinanceTrackerApp({super.key});

  @override
  State<PersonalFinanceTrackerApp> createState() =>
      _PersonalFinanceTrackerAppState();
}

class _PersonalFinanceTrackerAppState extends State<PersonalFinanceTrackerApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<TransactionCubit>(create: (_) => getIt<TransactionCubit>()),
    ], child: MaterialApp.router(
      title: 'Personal Finance Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: AppRoutes.router,
    ));
  }
}
