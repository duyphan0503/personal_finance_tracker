# Personal Finance Tracker (Flutter)

A mobile application that helps users track daily income, expenses, and manage monthly budgets.
The project is built with **Flutter (Dart 3)** following **Clean Architecture** and **Cubit (Bloc)** for scalable and maintainable development.

This project is used as a **training internship project** and demonstrates real-world mobile development practices, including authentication, state management, secure storage, charts, and CI/CD.

---

## 🚀 Features
- 🔐 Authentication with **Supabase Auth (PKCE)**
- 💰 Income & Expense management (CRUD)
- 🏷 Category tagging for transactions
- 📊 Monthly reports & category-based charts
- 📅 Monthly budget tracking per category
- 🔁 Secure session persistence
- 📱 Responsive UI using **Material 3**
- 🧭 Structured navigation with bottom tabs

---

## 🛠 Tech Stack

### Mobile
- **Flutter** (Dart 3)
- Material 3
- Responsive UI

### Architecture & State Management
- Clean Architecture
- Feature-based structure
- MVVM principles
- **Cubit (flutter_bloc)**
- Equatable

### Backend & Networking
- **Supabase**
  - Auth (PKCE)
  - Postgres database
  - Realtime & PostgREST
- REST API
- Dio (with interceptors)

### Data & Storage
- Flutter Secure Storage (session persistence)
- shared_preferences

### UI & Visualization
- fl_chart (reports & analytics)
- go_router (navigation)
- Lottie animations

### Logging & Error Handling
- Structured logging (`logger`)
- Graceful error handling (try-catch)

### Testing & DevOps
- Unit Testing
- Widget Testing
- Git & GitHub
- CI/CD with **GitHub Actions**
- Flutter Flavors
- Easy Localization

---

## 🧱 Architecture Overview

This project follows **Clean Architecture** to ensure:
- Separation of concerns
- Testability
- Scalability

### Layer Structure
Presentation → Domain → Data

- **Presentation**: UI, Cubit, State
- **Domain**: Use cases, Entities, Repository contracts
- **Data**: Repository implementations, Datasources (Supabase)

Each feature is isolated to avoid tight coupling and simplify future expansion.

---

## 📁 Folder Structure

lib/
├─ core/
│ ├─ error/
│ ├─ network/
│ ├─ utils/
│ └─ widgets/
├─ features/
│ ├─ auth/
│ │ ├─ data/
│ │ ├─ domain/
│ │ └─ presentation/
│ ├─ transaction/
│ ├─ budget/
│ └─ report/
├─ app/
│ ├─ router/
│ └─ theme/
└─ main.dart

---

## 🔄 State Management Strategy

- **Cubit** is used for predictable and testable state flows.
- Business logic is handled inside Cubit, not UI.
- States are immutable and compared using `Equatable`.

Example:
```dart
context.read<TransactionCubit>().loadTransactions();
```
🧪 Testing
The project includes basic unit and widget tests to:
    • Validate business logic
    • Ensure safe refactoring
    • Prevent regressions
Test structure:
test/
 ├─ transaction/
 │   └─ transaction_cubit_test.dart
 ├─ budget/
 │   └─ budget_cubit_test.dart
⚙️ CI/CD
GitHub Actions is configured to automatically run checks on every push and pull request.
Current Pipeline
    • Install dependencies
    • Run flutter analyze
This ensures code quality and prevents breaking changes from being merged.
🖼 Screenshots
(Add 3–5 screenshots here)
    • Login screen
    • Transaction list
    • Add transaction
    • Budget overview
    • Monthly report chart

▶️ How to Run the Project
Prerequisites
    • Flutter SDK (>= 3.x)
    • Supabase project
Steps
git clone https://github.com/duyphan0503/personal_finance_tracker.git
cd personal_finance_tracker
flutter pub get
Create a .env file:
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
Run the app:
flutter run
📌 Future Improvements
    • Refresh token handling
    • Offline-first support
    • Golden tests for UI
    • Advanced analytics
    • App release pipeline (Codemagic)

👤 Author
Phan Bao Duy
Flutter Developer Fresher
    • GitHub: https://github.com/duyphan0503
    • LinkedIn: https://linkedin.com/in/duyphan0503
