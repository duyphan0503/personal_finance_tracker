import 'package:injectable/injectable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@lazySingleton
class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSource({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  void initAuthListener() {
    _firebaseAuth.authStateChanges().listen((user) async {
      if (user != null) {
        // Create or update user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'email': user.email,
          'full_name': user.displayName ?? '',
          'created_at': FieldValue.serverTimestamp(),
          'updated_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    });
  }

  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(fullName);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  /// Handles Firebase Auth exceptions and converts them to readable messages
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found for that email.');
      case 'wrong-password':
        return Exception('Wrong password provided for that user.');
      case 'email-already-in-use':
        return Exception('The account already exists for that email.');
      case 'weak-password':
        return Exception('The password provided is too weak.');
      case 'invalid-email':
        return Exception('The email address is not valid.');
      default:
        return Exception('Authentication failed: ${e.message}');
    }
  }
}
