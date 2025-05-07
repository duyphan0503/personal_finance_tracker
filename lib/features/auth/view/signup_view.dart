import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_input_field.dart';
import '../../../routes/app_routes.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true; // Track whether password is visible or not

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003366),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Image.asset('assets/images/signup.png', height: 150),
                const SizedBox(height: 40),

                // Full Name
                SizedBox(
                  width: 300,
                  child: CustomInputField(hintText: 'Full Name', controller: nameController),
                ),
                const SizedBox(height: 40),

                // Email
                SizedBox(
                  width: 300,
                  child: CustomInputField(hintText: 'Email', controller: emailController),
                ),
                const SizedBox(height: 40),

                // Password
                SizedBox(
                  width: 300,
                  child: CustomInputField(
                    hintText: 'Password',
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Sign Up button
                SizedBox(
                  width: 300,
                  child: CustomButton(
                    text: 'Sign Up',
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Text below
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                  child: const Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Color(0xFF003366),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
