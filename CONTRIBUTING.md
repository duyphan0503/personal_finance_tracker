# Contributing to Personal Finance Tracker

Thank you for your interest in contributing to Personal Finance Tracker! This document provides guidelines and information for contributors.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.7.2)
- Dart SDK (>=3.7.2)
- Git
- Firebase project (see [Firebase Setup Guide](docs/FIREBASE_SETUP.md))

### Development Setup

1. **Fork and clone the repository:**
   ```bash
   git clone https://github.com/your-username/personal_finance_tracker.git
   cd personal_finance_tracker
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase configuration:**
   - Copy `lib/config/env.dart.example` to `lib/config/env.dart`
   - Follow the [Firebase Setup Guide](docs/FIREBASE_SETUP.md)

4. **Generate code:**
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Run the app:**
   ```bash
   flutter run
   ```

## 📝 Development Guidelines

### Code Style

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Architecture

This project follows **Clean Architecture** principles:

```
lib/
├── features/          # Feature modules (auth, transactions, etc.)
│   ├── [feature]/
│   │   ├── cubit/     # State management (BLoC)
│   │   ├── data/      # Data layer (repositories, data sources)
│   │   ├── model/     # Data models
│   │   └── view/      # UI components
├── shared/            # Shared utilities and widgets
├── config/            # App configuration
└── routes/            # Navigation
```

### State Management

- Use **BLoC/Cubit** for state management
- Follow BLoC naming conventions
- Keep business logic in the BLoC layer
- UI should only handle presentation logic

### Data Layer

- Repository pattern for data access
- Separate remote and local data sources
- Use dependency injection (GetIt + Injectable)
- Handle errors gracefully

## 🛠️ Making Changes

### Branch Naming

Use descriptive branch names:
- `feature/add-expense-categories`
- `bugfix/transaction-date-validation`
- `improvement/enhance-ui-performance`

### Commit Messages

Follow conventional commit format:
```
type(scope): description

feat(auth): add Google sign-in functionality
fix(transactions): resolve date picker crash
docs(readme): update installation instructions
refactor(budget): improve calculation logic
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

### Pull Request Process

1. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes:**
   - Write clean, documented code
   - Add tests for new functionality
   - Update documentation if needed

3. **Test your changes:**
   ```bash
   flutter test
   flutter analyze
   ```

4. **Commit your changes:**
   ```bash
   git add .
   git commit -m "feat(feature): add new functionality"
   ```

5. **Push to your fork:**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request:**
   - Use a clear, descriptive title
   - Explain what your changes do
   - Reference any related issues
   - Include screenshots for UI changes

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/auth/auth_test.dart
```

### Writing Tests

- Write unit tests for business logic
- Write widget tests for UI components
- Use mocks for external dependencies
- Follow AAA pattern (Arrange, Act, Assert)

Example test structure:
```dart
group('AuthCubit', () {
  late AuthCubit authCubit;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    authCubit = AuthCubit(mockRepository);
  });

  test('should emit authenticated state when login succeeds', () async {
    // Arrange
    when(() => mockRepository.signIn(any(), any()))
        .thenAnswer((_) async => mockUser);

    // Act
    await authCubit.signIn('email', 'password');

    // Assert
    expect(authCubit.state.status, AuthStatus.authenticated);
  });
});
```

## 📚 Documentation

### Code Documentation

- Document public APIs with dartdoc comments
- Include usage examples for complex functions
- Document class purposes and responsibilities

Example:
```dart
/// Service for managing user authentication state.
/// 
/// This service handles sign-in, sign-up, and sign-out operations
/// using Firebase Authentication.
/// 
/// Example usage:
/// ```dart
/// final authService = getIt<AuthService>();
/// final user = await authService.signIn('email', 'password');
/// ```
class AuthService {
  /// Signs in a user with email and password.
  /// 
  /// Returns the authenticated [User] or throws an [AuthException]
  /// if authentication fails.
  Future<User> signIn(String email, String password) async {
    // Implementation
  }
}
```

### Adding Documentation

- Update README.md for major features
- Add guides to `docs/` folder
- Update API documentation
- Include screenshots for UI changes

## 🐛 Bug Reports

When reporting bugs, please include:

1. **Steps to reproduce**
2. **Expected behavior**
3. **Actual behavior**
4. **Screenshots/videos** (if applicable)
5. **Device information:**
   - Flutter version
   - Dart version
   - Operating system
   - Device model

Use this template:
```markdown
## Bug Description
Brief description of the bug

## Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Screenshots
If applicable, add screenshots

## Environment
- Flutter version: 
- Dart version: 
- Device: 
- OS version: 
```

## 💡 Feature Requests

When suggesting features:

1. **Describe the problem** the feature would solve
2. **Explain the proposed solution**
3. **Consider alternatives** you've thought about
4. **Provide mockups** for UI features (if applicable)

## 🔍 Code Review

### For Reviewers

- Be constructive and specific in feedback
- Focus on code quality, not personal preferences
- Suggest improvements rather than just pointing out problems
- Approve when the code meets quality standards

### For Contributors

- Respond to feedback promptly
- Ask questions if feedback is unclear
- Make requested changes in separate commits
- Thank reviewers for their time

## 📋 Development Checklist

Before submitting a PR, ensure:

- [ ] Code follows project style guidelines
- [ ] All tests pass
- [ ] New functionality has tests
- [ ] Documentation is updated
- [ ] Commit messages are clear
- [ ] No sensitive data is committed
- [ ] App builds without warnings
- [ ] Performance is not negatively impacted

## 🎯 Areas for Contribution

We welcome contributions in these areas:

### High Priority
- [ ] Unit and integration tests
- [ ] Performance optimizations
- [ ] Accessibility improvements
- [ ] Error handling enhancements

### Medium Priority
- [ ] UI/UX improvements
- [ ] Additional chart types for reports
- [ ] Export/import functionality
- [ ] Multi-currency support

### Low Priority
- [ ] Dark theme enhancements
- [ ] Animations and transitions
- [ ] Additional authentication methods
- [ ] Offline support

## 📞 Getting Help

- **General questions:** Open a discussion
- **Bug reports:** Create an issue
- **Feature requests:** Create an issue with the feature template
- **Security issues:** Email security@yourproject.com

## 📜 License

By contributing to Personal Finance Tracker, you agree that your contributions will be licensed under the MIT License.

## 🙏 Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes for significant contributions
- GitHub contributors page

Thank you for contributing to Personal Finance Tracker! 🎉