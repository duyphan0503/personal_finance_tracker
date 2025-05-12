import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/app.dart';
import 'package:personal_finance_tracker/features/transaction/cubit/transaction_cubit.dart';
import 'package:personal_finance_tracker/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:personal_finance_tracker/features/transaction/data/repository/transaction_repository.dart';
import 'package:personal_finance_tracker/injection.dart';

import 'config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initSupabase();
  configureDependencies();

  runApp(const PersonalFinanceTrackerApp());
}