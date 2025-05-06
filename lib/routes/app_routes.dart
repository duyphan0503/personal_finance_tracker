import 'package:flutter/material.dart';
import '../../features/auth/view/login_view.dart';
import '../../features/auth/view/signup_view.dart';

class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';

  static final routes = <String, WidgetBuilder>{
    login: (_) => const LoginView(),
    signup: (_) => const SignUpView(),
  };
}