import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../injection.dart';
import '../../auth/cubit/auth_cubit.dart'; // Để sử dụng SystemNavigator

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  bool isTwoFactorEnabled = false; // Biến theo dõi trạng thái của switch 2FA

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account & Security',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildListTile(
            title: 'Account',
            style: const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
            icon: Icons.person,
            iconColor: Colors.black,
            onTap: () => _handleAccountTap(context),
          ),
          _buildListTile(
            title: 'Email',
            style: const TextStyle(fontSize: 18),
            icon: Icons.email,
            iconColor: Colors.black,
            onTap: () => _handleEmailTap(context),
          ),
          _buildListTile(
            title: 'Password',
            style: const TextStyle(fontSize: 18),
            icon: Icons.lock,
            iconColor: Colors.black,
            onTap: () => _handlePasswordTap(context),
          ),
          _buildListTile(
            title: 'Two-Factor Authentication',
            style: const TextStyle(fontSize: 18),
            icon: Icons.security,
            iconColor: Colors.orange,
            onTap: () => _handleTwoFactorTap(context),
          ),
          const SizedBox(height: 24),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required TextStyle style,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFD7E2F3), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: style,
        ),
        onTap: onTap,
        horizontalTitleGap: 0,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF8915), // Màu cam
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () => _handleLogout(context),
      child: const Text(
        'Log Out',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  void _handleAccountTap(BuildContext context) {
    // Điều hướng đến phần cài đặt tài khoản
  }

  void _handleEmailTap(BuildContext context) {
    // Điều hướng đến phần cài đặt email
  }

  void _handlePasswordTap(BuildContext context) {
    // Điều hướng đến phần cài đặt mật khẩu
  }

  void _handleTwoFactorTap(BuildContext context) {
    // Điều hướng đến phần cài đặt 2FA
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Đóng ứng dụng
              await getIt<AuthCubit>().signOut();
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
