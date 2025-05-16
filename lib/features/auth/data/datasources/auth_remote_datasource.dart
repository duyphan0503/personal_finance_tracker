import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;

  AuthRemoteDataSource({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  void initAuthListener() {
    _supabaseClient.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      final session = data.session;
      final user = session?.user;
      if (user != null &&
          (event == AuthChangeEvent.signedIn ||
              event == AuthChangeEvent.userUpdated)) {
        final fullName = user.userMetadata?['full_name'] as String? ?? '';
        await _supabaseClient.from('users').upsert({
          'id': user.id,
          'full_name': fullName,
        }, onConflict: 'id');
      }
    });
  }

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

  Future<AuthResponse> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await _supabaseClient.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  Stream<AuthState> authStateChanges() {
    return _supabaseClient.auth.onAuthStateChange;
  }
}
