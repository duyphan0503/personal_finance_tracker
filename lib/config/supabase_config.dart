import 'package:personal_finance_tracker/config/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth/data/datasources/local/secure_session_storage.dart';

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: supUrl,
    anonKey: supApiKey,
    debug: true,
    authOptions: const FlutterAuthClientOptions(
      autoRefreshToken: false,
      authFlowType: AuthFlowType.pkce,
    ).copyWith(localStorage: SecureSessionStorage()),
  );
}
