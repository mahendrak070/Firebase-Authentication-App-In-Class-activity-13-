import 'package:flutter/material.dart';
import 'auth_service.dart';

class SignUpScreen extends StatefulWidget {
  final AuthService authService;
  const SignUpScreen({super.key, required this.authService});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _message;

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _message = "Processing registration...";
      });

      // Perform sign-up
      final user = await widget.authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        setState(() {
          _message = 'Successfully registered ${user.email}';
        });
        Navigator.pop(context); // Go back or to login screen after success
      } else {
        setState(() {
          _message = 'Registration failed. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: EdgeInsets.all(16.0),
            color: Colors.grey[850],
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Create an Account',
                      style: TextStyle(fontSize: 24.0, color: Colors.white),
                    ),
                    SizedBox(height: 24.0),
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Enter at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: _signUp,
                      child: Text('Register'),
                    ),
                    if (_message != null)
                      Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          _message!,
                          style: TextStyle(
                              color: _message!.contains('failed')
                                  ? Colors.redAccent
                                  : Colors.green),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
