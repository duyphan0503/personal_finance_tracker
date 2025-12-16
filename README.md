# Personal Finance Tracker (Flutter)

A mobile application that helps users track daily income, expenses, and manage monthly budgets.
The project is built with **Flutter (Dart 3)** following **Clean Architecture** and **Cubit (Bloc)** for scalable and maintainable development.

This project is used as a **training internship project** and demonstrates real-world mobile development practices, including authentication, state management, secure storage, and charts.

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
- **Cubit (flutter_bloc)**
- Equatable
- DI: **GetIt** & **Injectable**

### Backend & Networking

- **Supabase**
  - Auth (PKCE)
  - Postgres database
  - Realtime & PostgREST
- REST API (via Supabase SDK)

### Data & Storage

- Flutter Secure Storage (session persistence)
- shared_preferences

### UI & Visualization

- fl_chart (reports & analytics)
- go_router (navigation)

### DevOps

- Git & GitHub
- CI/CD with **GitHub Actions** (Analyze)

---

## 🧱 Architecture Overview

This project follows **Clean Architecture** to ensure:

- Separation of concerns
- Scalability
- Maintainability

### Layer Structure

Presentation → Domain → Data

- **Presentation**: UI, Cubit, State
- **Domain**: Use cases, Entities, Repository contracts
- **Data**: Repository implementations, Datasources (Supabase)

Each feature is isolated to avoid tight coupling and simplify future expansion.

---

## 📁 Folder Structure (Feature-First Clean Architecture)

```text
lib/
├── app/
│   ├── router/
│   └── theme/
├── config/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── budget/
│   ├── category/
│   ├── dashboard/
│   ├── report/
│   ├── settings/
│   └── transaction/
├── gen/
├── shared/
│   ├── services/
│   ├── utils/
│   └── widgets/
├── app.dart
├── injection.dart
└── main.dart
```

---

## 🔄 State Management Strategy

- **Cubit** is used for predictable and testable state flows.
- Business logic is handled inside Cubit, not UI.
- States are immutable and compared using `Equatable`.

Example:

```dart
context.read<TransactionCubit>().loadTransactions();
```

---

## ⚙️ CI/CD

GitHub Actions is configured to automatically run checks on every push and pull request.

**Current Pipeline:**

- Install dependencies
- Run flutter analyze

This ensures code quality and prevents breaking changes from being merged.

---

## 🖼 Screenshots

(Add 3–5 screenshots here)

- Login screen
- Dashboard
- Add transaction
- Budget overview
- Monthly report chart

---

## ▶️ How to Run the Project

### Prerequisites

- Flutter SDK (>= 3.7.x)
- Supabase project

### Steps

1. Clone the repository:

   ```bash
   git clone https://github.com/duyphan0503/personal_finance_tracker.git
   cd personal_finance_tracker
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Create a `.env` file in the root directory:

   ```env
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_anon_key
   ```

4. Run the app:

   ```bash
   flutter run
   ```

---

## 📌 Future Improvements

- Unit & Widget Tests
- Advanced analytics
- Offline-first support
- Dark mode toggle

---

## 👤 Author

**Phan Bao Duy**  
Flutter Developer Fresher

- [GitHub](https://github.com/duyphan0503)
- [LinkedIn](https://linkedin.com/in/duyphan0503)
