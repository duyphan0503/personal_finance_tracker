# Firebase Setup Guide

This document provides step-by-step instructions for setting up Firebase for the Personal Finance Tracker app.

## Prerequisites

- A Google account
- Flutter development environment set up
- Android Studio or VS Code

## 1. Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or "Create a project"
3. Enter your project name (e.g., "personal-finance-tracker")
4. Choose whether to enable Google Analytics (recommended)
5. Select or create a Google Analytics account if you enabled it
6. Click "Create project"

## 2. Set Up Authentication

1. In the Firebase Console, navigate to "Authentication" in the left sidebar
2. Click on the "Sign-in method" tab
3. Enable "Email/Password" authentication:
   - Click on "Email/Password"
   - Toggle "Enable"
   - Click "Save"

## 3. Set Up Cloud Firestore

1. In the Firebase Console, navigate to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (you can secure it later)
4. Select a location for your database (choose the closest to your users)
5. Click "Done"

### Firestore Security Rules

Once your database is created, update the security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Categories are readable by all authenticated users
    match /categories/{document} {
      allow read: if request.auth != null;
      allow write: if false; // Only admins can modify categories
    }
    
    // Transactions belong to authenticated users
    match /transactions/{document} {
      allow read, write: if request.auth != null && 
        resource.data.user_id == request.auth.uid;
    }
    
    // Budgets belong to authenticated users
    match /budgets/{document} {
      allow read, write: if request.auth != null && 
        resource.data.user_id == request.auth.uid;
    }
    
    // App configuration (read-only for clients)
    match /app_config/{document} {
      allow read: if true;
      allow write: if false;
    }
  }
}
```

## 4. Add Firebase to Your Flutter App

### For Android:

1. In the Firebase Console, click "Add app" and select Android
2. Enter your Android package name:
   - You can find this in `android/app/build.gradle` under `applicationId`
   - Default: `com.example.personal_finance_tracker`
3. Enter app nickname (optional): "Personal Finance Tracker Android"
4. Enter SHA-1 key (optional for now, required for some features later)
5. Click "Register app"
6. Download the `google-services.json` file
7. Place it in `android/app/` directory

### For iOS:

1. In the Firebase Console, click "Add app" and select iOS
2. Enter your iOS bundle ID:
   - You can find this in `ios/Runner.xcodeproj/project.pbxproj`
   - Default: `com.example.personalFinanceTracker`
3. Enter app nickname (optional): "Personal Finance Tracker iOS"
4. Click "Register app"
5. Download the `GoogleService-Info.plist` file
6. Place it in `ios/Runner/` directory
7. Add it to your Xcode project (drag and drop into Runner folder in Xcode)

## 5. Configure Your App

1. Copy `lib/config/env.dart.example` to `lib/config/env.dart`
2. In the Firebase Console, go to Project Settings (gear icon)
3. Scroll down to "Your apps" section
4. Click on your web app or "Add app" → "Web"
5. Copy the Firebase configuration values
6. Update `lib/config/env.dart` with your actual Firebase configuration:

```dart
const String firebaseApiKey = "your-actual-api-key";
const String firebaseAuthDomain = "your-project.firebaseapp.com";
const String firebaseProjectId = "your-project-id";
const String firebaseStorageBucket = "your-project.appspot.com";
const String firebaseMessagingSenderId = "123456789";
const String firebaseAppId = "1:123456789:web:actual-app-id";
```

## 6. Add Default Categories

The app will automatically create default categories on first run. If you want to add them manually:

1. Go to Firestore Database in Firebase Console
2. Create a collection called "categories"
3. Add documents with the following structure:

```json
{
  "name": "Food",
  "type": "expense",
  "icon": "restaurant",
  "color": "orange",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

Repeat for other categories like Shopping, Housing, Salary, etc.

## 7. Test Your Setup

1. Run the app: `flutter run`
2. Try to sign up with a new account
3. Check the Authentication section in Firebase Console to see if the user was created
4. Check Firestore to see if the user document was created

## Security Best Practices

1. **Enable App Check** (recommended for production):
   - Go to Firebase Console → App Check
   - Register your app and enable enforcement

2. **Secure your Firestore rules**:
   - Review and test your security rules
   - Use the Rules Playground in Firebase Console

3. **Enable monitoring**:
   - Set up Firebase Performance Monitoring
   - Enable Crashlytics for error reporting

4. **Environment variables**:
   - Never commit `env.dart` to version control
   - Use different Firebase projects for development and production

## Troubleshooting

### Common Issues:

1. **Build errors after adding Firebase**:
   - Make sure `google-services.json` is in the correct location
   - Clean and rebuild: `flutter clean && flutter pub get && flutter run`

2. **Authentication not working**:
   - Check if Email/Password is enabled in Firebase Console
   - Verify your Firebase configuration in `env.dart`

3. **Firestore permission denied**:
   - Check your Firestore security rules
   - Make sure the user is authenticated

4. **App not connecting to Firebase**:
   - Verify internet connection
   - Check Firebase project status
   - Ensure Firebase configuration is correct

### Getting Help:

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)

## Production Deployment

Before deploying to production:

1. Create a separate Firebase project for production
2. Update security rules for production
3. Enable App Check
4. Set up monitoring and analytics
5. Configure backup strategies
6. Review and optimize Firestore usage

---

## Quick Setup Checklist

- [ ] Create Firebase project
- [ ] Enable Email/Password authentication
- [ ] Set up Cloud Firestore
- [ ] Add Android app to Firebase project
- [ ] Add iOS app to Firebase project
- [ ] Download and place configuration files
- [ ] Update `lib/config/env.dart` with your Firebase config
- [ ] Update Firestore security rules
- [ ] Test authentication and database operations
- [ ] Set up monitoring (optional but recommended)

Once you've completed these steps, your Personal Finance Tracker app should be ready to use with Firebase!