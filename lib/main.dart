import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/app.dart';
import 'package:personal_finance_tracker/features/auth/data/repositories/auth_repository.dart';
import 'package:personal_finance_tracker/injection.dart';
import 'package:personal_finance_tracker/shared/services/firebase_initialization_service.dart';

import 'config/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await initFirebase();
    
    // Configure dependency injection
    configureDependencies();
    
    // Initialize authentication listener
    await getIt<AuthRepository>().initAuthListener();
    
    // Initialize default app data (categories, etc.)
    final initService = getIt<FirebaseInitializationService>();
    await initService.initializeAppConfigurations();

    runApp(const PersonalFinanceTrackerApp());
  } catch (e, stackTrace) {
    // Handle initialization errors
    print('Failed to initialize app: $e');
    print('Stack trace: $stackTrace');
    
    // You can show an error screen or fallback UI here
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Failed to initialize app',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Error: $e',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Restart the app
                  main();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
