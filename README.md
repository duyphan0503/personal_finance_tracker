# Personal Finance Tracker

A professional Flutter application for managing personal finances with Firebase integration.

## 🌟 Features

- **User Authentication**: Secure sign-up and sign-in with Firebase Auth
- **Expense Tracking**: Add, edit, and delete transactions
- **Budget Management**: Set and monitor budgets by category
- **Financial Reports**: Visual reports and analytics
- **Category Management**: Organize transactions by categories
- **Secure Data Storage**: Cloud Firestore for reliable data persistence

## 🏗️ Architecture

This project follows **Clean Architecture** principles with:

- **Presentation Layer**: Flutter BLoC for state management
- **Domain Layer**: Business logic and use cases
- **Data Layer**: Firebase services and repositories
- **Dependency Injection**: Get_it with Injectable for clean dependency management

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.7.2)
- Firebase project setup
- Android Studio / VS Code

### Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)

2. Enable the following services:
   - **Authentication** (Email/Password)
   - **Cloud Firestore**

3. Add your Firebase configuration in `lib/config/env.dart`:

```dart
const String firebaseApiKey = "your-firebase-api-key";
const String firebaseAuthDomain = "your-project.firebaseapp.com";
const String firebaseProjectId = "your-project-id";
const String firebaseStorageBucket = "your-project.appspot.com";
const String firebaseMessagingSenderId = "123456789";
const String firebaseAppId = "1:123456789:web:abcdef123456";
```

4. Add Firebase configuration files:
   - `android/app/google-services.json` (for Android)
   - `ios/Runner/GoogleService-Info.plist` (for iOS)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/duyphan0503/personal_finance_tracker.git
cd personal_finance_tracker
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate injection files:
```bash
flutter packages pub run build_runner build
```

4. Run the app:
```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── config/                 # Configuration files
├── features/               # Feature modules
│   ├── auth/              # Authentication
│   ├── budget/            # Budget management
│   ├── category/          # Category management
│   ├── dashboard/         # Main dashboard
│   ├── report/            # Financial reports
│   ├── settings/          # App settings
│   └── transaction/       # Transaction management
├── routes/                # Navigation routes
├── shared/                # Shared widgets and utilities
├── app.dart               # Main app widget
├── injection.dart         # Dependency injection setup
└── main.dart              # Entry point
```

## 🛠️ Technologies Used

- **Flutter**: Cross-platform mobile development
- **Firebase Auth**: User authentication
- **Cloud Firestore**: NoSQL database
- **Flutter BLoC**: State management
- **Get_it + Injectable**: Dependency injection
- **Go Router**: Navigation
- **FL Chart**: Data visualization
- **Flutter Secure Storage**: Secure local storage

## 📊 Firebase Collections Structure

### Users
```json
{
  "id": "user_uid",
  "email": "user@example.com",
  "full_name": "User Name",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

### Categories
```json
{
  "id": "category_id",
  "name": "Food",
  "type": "expense", // or "income"
  "created_at": "timestamp"
}
```

### Transactions
```json
{
  "id": "transaction_id",
  "user_id": "user_uid",
  "category_id": "category_id",
  "amount": 100.00,
  "note": "Lunch",
  "transaction_date": "timestamp",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

### Budgets
```json
{
  "id": "budget_id",
  "user_id": "user_uid",
  "category_id": "category_id",
  "amount": 500.00,
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

## 🔧 Development

### Code Generation

When adding new dependencies or changing injection configurations:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Testing

```bash
flutter test
```

### Building

For Android:
```bash
flutter build apk --release
```

For iOS:
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Duy Phan** - [GitHub Profile](https://github.com/duyphan0503)

---

⭐ Star this repository if you found it helpful!