import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/app.dart';
import 'package:personal_finance_tracker/features/auth/data/repositories/auth_repository.dart';
import 'package:personal_finance_tracker/injection.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await initSupabase();
  configureDependencies();
  await getIt<AuthRepository>().initAuthListener();

  runApp(const PersonalFinanceTrackerApp());
}
