import 'package:injectable/injectable.dart';
import 'package:personal_finance_tracker/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';

@lazySingleton
class AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepository({required AuthRemoteDataSource dataSource})
    : _dataSource = dataSource;

  Future<void> initAuthListener() async {
    _dataSource.initAuthListener();
    return Future.value();
  }

  Future<User?> getCurrentUser() async {
    return await _dataSource.getCurrentUser();
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _dataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await _dataSource.signUpWithEmailAndPassword(
      email: email,
      password: password,
      fullName: fullName,
    );
  }

  Future<void> signOut() async {
    await _dataSource.signOut();
  }

  Stream<User?> authStateChanges() {
    return _dataSource.authStateChanges();
  }
}
