// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up Method
  Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ensure result.user is returned without casting
      return result.user; // Return the User if successful, or null on failure
    } catch (e) {
      print('SignUp Error: $e');
      return null; // Return null if there's an error
    }
  }

  // Sign In Method
  Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Return the User if successful, or null on failure
      return result.user;
    } catch (e) {
      print('SignIn Error: $e');
      return null;
    }
  }

  // Sign Out Method
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get Current User
  User? get currentUser => _auth.currentUser;
}
