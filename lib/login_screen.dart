import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'profile_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;
  const LoginScreen({super.key, required this.authService});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _message;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _message = "Processing login...";
      });

      final user = await widget.authService.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        setState(() {
          _message = 'Login successful for ${user.email}';
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfileScreen(authService: widget.authService),
          ),
        );
      } else {
        setState(() {
          _message = 'Login failed. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Login"),
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
                      'Welcome Back',
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
                      onPressed: _login,
                      child: Text('Login'),
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
