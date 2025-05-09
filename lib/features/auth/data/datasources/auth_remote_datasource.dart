import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;

  AuthRemoteDataSource({required SupabaseClient supabaseClient}) 
      : _supabaseClient = supabaseClient;

  Future<User?> getCurrentUser() async {
    return _supabaseClient.auth.currentUser;
  }

  Future<AuthResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  Stream<AuthState> authStateChanges() {
    return _supabaseClient.auth.onAuthStateChange;
  }
}
