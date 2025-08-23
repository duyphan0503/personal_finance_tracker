/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'Personal Finance Tracker';
  static const String appVersion = '1.0.0';
  
  // Database Collections
  static const String usersCollection = 'users';
  static const String categoriesCollection = 'categories';
  static const String transactionsCollection = 'transactions';
  static const String budgetsCollection = 'budgets';
  
  // Default Values
  static const int defaultPageSize = 20;
  static const int maxTransactionsPerPage = 50;
  static const double maxBudgetAmount = 1000000.0;
  static const double minTransactionAmount = 0.01;
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String monthYearFormat = 'MMMM yyyy';
  
  // Currency
  static const String defaultCurrency = 'VND';
  static const String currencySymbol = '₫';
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxNoteLength = 200;
  
  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String firstLaunchKey = 'first_launch';
  
  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String authErrorMessage = 'Authentication failed. Please sign in again.';
  
  // Success Messages
  static const String transactionSavedMessage = 'Transaction saved successfully';
  static const String budgetSavedMessage = 'Budget saved successfully';
  static const String profileUpdatedMessage = 'Profile updated successfully';
  
  // Default Categories (for initial data)
  static const List<Map<String, dynamic>> defaultCategories = [
    {
      'name': 'Food',
      'type': 'expense',
      'icon': 'restaurant',
      'color': 'orange',
    },
    {
      'name': 'Shopping',
      'type': 'expense',
      'icon': 'shopping_bag',
      'color': 'indigo',
    },
    {
      'name': 'Housing',
      'type': 'expense',
      'icon': 'home',
      'color': 'blue',
    },
    {
      'name': 'Transportation',
      'type': 'expense',
      'icon': 'directions_car',
      'color': 'green',
    },
    {
      'name': 'Salary',
      'type': 'income',
      'icon': 'money_outlined',
      'color': 'teal',
    },
    {
      'name': 'Freelance',
      'type': 'income',
      'icon': 'work',
      'color': 'purple',
    },
    {
      'name': 'Investments',
      'type': 'income',
      'icon': 'trending_up',
      'color': 'indigo',
    },
  ];
}

/// API endpoint constants
class ApiConstants {
  static const String baseUrl = 'https://your-api-url.com';
  static const String apiVersion = 'v1';
  
  // Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}

/// Regular expressions for validation
class RegexConstants {
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  static final RegExp phoneRegex = RegExp(
    r'^[+]?[0-9]{10,15}$',
  );
  
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$',
  );
  
  static final RegExp nameRegex = RegExp(
    r'^[a-zA-Z\s]+$',
  );
  
  static final RegExp amountRegex = RegExp(
    r'^\d+(\.\d{1,2})?$',
  );
}