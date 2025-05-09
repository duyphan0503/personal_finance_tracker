import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/auth_remote_datasource.dart';

@lazySingleton
class AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepository({required AuthRemoteDataSource dataSource}) 
      : _dataSource = dataSource;

  Future<User?> getCurrentUser() async {
    return await _dataSource.getCurrentUser();
  }

  Future<AuthResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _dataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _dataSource.signOut();
  }

  Stream<AuthState> authStateChanges() {
    return _dataSource.authStateChanges();
  }
}
