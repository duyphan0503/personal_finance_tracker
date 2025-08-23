import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Centralized error handling utility for the application
class ErrorHandler {
  /// Handles Firebase Auth exceptions and returns user-friendly messages
  static String handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'Authentication failed: ${e.message ?? 'Unknown error'}';
    }
  }

  /// Handles Firestore exceptions and returns user-friendly messages
  static String handleFirestoreError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'You do not have permission to perform this action.';
      case 'unavailable':
        return 'Service is currently unavailable. Please try again later.';
      case 'not-found':
        return 'The requested document was not found.';
      case 'already-exists':
        return 'The document already exists.';
      case 'resource-exhausted':
        return 'Quota exceeded. Please try again later.';
      case 'failed-precondition':
        return 'Operation failed. Please check your data and try again.';
      case 'aborted':
        return 'Operation was aborted. Please try again.';
      case 'out-of-range':
        return 'Invalid data range provided.';
      case 'unimplemented':
        return 'This feature is not yet implemented.';
      case 'internal':
        return 'Internal error occurred. Please try again.';
      case 'deadline-exceeded':
        return 'Request timed out. Please try again.';
      case 'cancelled':
        return 'Operation was cancelled.';
      default:
        return 'Database error: ${e.message ?? 'Unknown error'}';
    }
  }

  /// Handles general exceptions and returns user-friendly messages
  static String handleGeneralError(Exception e) {
    final message = e.toString();
    
    // Check if it's a known Firebase error
    if (e is FirebaseAuthException) {
      return handleFirebaseAuthError(e);
    } else if (e is FirebaseException) {
      return handleFirestoreError(e);
    }
    
    // Handle common network/connection errors
    if (message.contains('SocketException') || 
        message.contains('NetworkException')) {
      return 'Network error. Please check your internet connection.';
    }
    
    if (message.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    }
    
    if (message.contains('FormatException')) {
      return 'Invalid data format received.';
    }
    
    // Return a generic message for unknown errors
    return 'An unexpected error occurred. Please try again.';
  }

  /// Logs error details for debugging (in development mode)
  static void logError(dynamic error, StackTrace? stackTrace, {
    String? context,
    Map<String, dynamic>? additionalData,
  }) {
    // In a production app, you would send this to a crash reporting service
    // like Firebase Crashlytics, Sentry, etc.
    
    print('=== ERROR LOG ===');
    if (context != null) print('Context: $context');
    print('Error: $error');
    if (stackTrace != null) print('Stack Trace: $stackTrace');
    if (additionalData != null) {
      print('Additional Data: $additionalData');
    }
    print('================');
  }
}

/// Custom exception classes for better error handling

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: $message';
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
  
  @override
  String toString() => 'ValidationException: $message';
}

class BusinessLogicException implements Exception {
  final String message;
  BusinessLogicException(this.message);
  
  @override
  String toString() => 'BusinessLogicException: $message';
}