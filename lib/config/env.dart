import 'package:flutter_dotenv/flutter_dotenv.dart';

final String supUrl = dotenv.env['SUPABASE_URL'] ?? '';
final String supApiKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

final String authUrl = "$supUrl/auth/v1";
