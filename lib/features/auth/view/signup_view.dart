import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_input_field.dart';
import '../../../routes/app_routes.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              CustomInputField(hintText: 'Full Name', controller: nameController),
              CustomInputField(hintText: 'Email', controller: emailController),
              CustomInputField(hintText: 'Password', controller: passwordController, obscureText: true),
              const SizedBox(height: 10),
              CustomButton(
                text: 'Sign Up',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                child: const Text("Already have an account?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
