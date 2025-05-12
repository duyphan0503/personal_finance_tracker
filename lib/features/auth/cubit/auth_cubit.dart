import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../data/repositories/auth_repository.dart';
import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _authStateSubscription;

  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState()) {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(state.copyWith(status: AuthStatus.authenticated, user: user));
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      }
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final response = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        emit(
          state.copyWith(status: AuthStatus.authenticated, user: response.user),
        );
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            errorMessage: 'Failed to sign in',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final response = await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
      );

      if (response.user != null) {
        emit(
          state.copyWith(status: AuthStatus.authenticated, user: response.user),
        );
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            errorMessage: 'Failed to sign up',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
