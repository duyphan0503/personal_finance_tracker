import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_finance_tracker/config/env.dart';

/// Initializes Firebase services for the application
Future<void> initFirebase() async {
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: firebaseApiKey,
        authDomain: firebaseAuthDomain,
        projectId: firebaseProjectId,
        storageBucket: firebaseStorageBucket,
        messagingSenderId: firebaseMessagingSenderId,
        appId: firebaseAppId,
      ),
    );

    // Configure Firestore settings
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // Configure Auth settings
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    
    print('Firebase initialized successfully');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
    rethrow;
  }
}
