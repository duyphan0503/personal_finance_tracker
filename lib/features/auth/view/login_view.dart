import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_input_field.dart';
import '../../../routes/app_routes.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome to Personal Finance Tracker', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              CustomInputField(hintText: 'Email', controller: emailController),
              CustomInputField(hintText: 'Password', controller: passwordController, obscureText: true),
              const SizedBox(height: 10),
              CustomButton(
                text: 'Login',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.signup);
                },
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
                child: const Text("Don't have an account?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
