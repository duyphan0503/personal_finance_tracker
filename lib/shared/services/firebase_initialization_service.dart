import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:personal_finance_tracker/shared/constants/app_constants.dart';

/// Service for initializing default data in Firebase
@lazySingleton
class FirebaseInitializationService {
  final FirebaseFirestore _firestore;

  FirebaseInitializationService(this._firestore);

  /// Initialize default categories if they don't exist
  Future<void> initializeDefaultCategories() async {
    try {
      final categoriesSnapshot = await _firestore
          .collection(AppConstants.categoriesCollection)
          .limit(1)
          .get();

      // Only create default categories if none exist
      if (categoriesSnapshot.docs.isEmpty) {
        final batch = _firestore.batch();

        for (final category in AppConstants.defaultCategories) {
          final categoryRef = _firestore
              .collection(AppConstants.categoriesCollection)
              .doc();

          batch.set(categoryRef, {
            ...category,
            'created_at': FieldValue.serverTimestamp(),
            'updated_at': FieldValue.serverTimestamp(),
          });
        }

        await batch.commit();
        print('Default categories initialized successfully');
      }
    } catch (e) {
      print('Error initializing default categories: $e');
      // Don't rethrow - this is not critical for app functionality
    }
  }

  /// Initialize app-wide configurations
  Future<void> initializeAppConfigurations() async {
    try {
      // Initialize default categories
      await initializeDefaultCategories();
      
      // Add any other initialization logic here
      // e.g., default settings, app configurations, etc.
      
    } catch (e) {
      print('Error during app initialization: $e');
    }
  }

  /// Check if the app is running for the first time
  Future<bool> isFirstRun() async {
    try {
      final configDoc = await _firestore
          .collection('app_config')
          .doc('initialization')
          .get();

      return !configDoc.exists;
    } catch (e) {
      print('Error checking first run: $e');
      return true; // Assume first run on error
    }
  }

  /// Mark the app as initialized
  Future<void> markAsInitialized() async {
    try {
      await _firestore
          .collection('app_config')
          .doc('initialization')
          .set({
        'initialized_at': FieldValue.serverTimestamp(),
        'app_version': AppConstants.appVersion,
      });
    } catch (e) {
      print('Error marking app as initialized: $e');
    }
  }
}