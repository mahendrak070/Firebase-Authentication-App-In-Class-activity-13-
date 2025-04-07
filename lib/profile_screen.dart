import 'package:flutter/material.dart';
import 'auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService authService;
  const ProfileScreen({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    final userEmail = authService.currentUser?.email ?? 'No Email';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16.0),
          color: Colors.grey[850],
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'User Profile',
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                ),
                SizedBox(height: 24.0),
                Text(
                  'Email: $userEmail',
                  style: TextStyle(fontSize: 18.0, color: Colors.white70),
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    // Implement password change functionality
                    _showChangePasswordDialog(context);
                  },
                  child: Text('Change Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        title: Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: passwordController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'New Password',
            labelStyle: TextStyle(color: Colors.white70),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
          ),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (passwordController.text.length >= 6) {
                try {
                  await authService.currentUser!
                      .updatePassword(passwordController.text);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Password changed successfully')),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Password must be at least 6 characters'),
                  ),
                );
              }
            },
            child: Text('Change', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
