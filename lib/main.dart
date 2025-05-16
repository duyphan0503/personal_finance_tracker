import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/app.dart';
import 'package:personal_finance_tracker/features/auth/data/repositories/auth_repository.dart';
import 'package:personal_finance_tracker/injection.dart';

import 'config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initSupabase();
  configureDependencies();
  await getIt<AuthRepository>().initAuthListener();

  runApp(const PersonalFinanceTrackerApp());
}
