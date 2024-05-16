/*
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thirdeyeapp/components/my_button.dart';
import 'package:thirdeyeapp/components/my_textfield.dart';
import 'package:thirdeyeapp/pages/spects.dart'; // Import HomePage
import 'package:thirdeyeapp/pages/loginpage.dart'; // Import LoginPage

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign up method
  void signUpUser(BuildContext context) async {
    try {
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();

      // Create user with email and password
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user details to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        // Add additional user details if needed
      });

      // Navigate to home page upon successful sign-up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      // Handle sign-up errors here
      String errorMessage = "Failed to sign up. Please try again.";

      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? "An error occurred";
      } else if (e is FirebaseException) {
        errorMessage = e.message ?? "An error occurred";
      }

      print("Sign up error: $errorMessage"); // Print the specific error message

      // Show alert message for sign-up failure
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sign Up Failed"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  // Navigate to login page
  void navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),

                // Logo
                const Icon(
                  Icons.person_add,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // Create an account message
                Text(
                  'Create an account to get started!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // Email
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // Password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // Sign up button
                MyButton(
                  onTap: () => signUpUser(context),
                ),

                const SizedBox(height: 25),

                // Or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25.0),

                // Google
                GestureDetector(
                  onTap: () {
                    // Implement Google sign-up logic
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/images/google.png',
                        height: 72,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // Already a member? Login now
                GestureDetector(
                  onTap: () {
                    navigateToLogin(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already a member?'),
                      const SizedBox(width: 4),
                      Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thirdeyeapp/components/my_button.dart';
import 'package:thirdeyeapp/components/my_button2.dart';
import 'package:thirdeyeapp/components/my_textfield.dart';
import 'package:thirdeyeapp/pages/spects.dart';
import 'package:thirdeyeapp/pages/loginpage.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key});

  // Firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // navigate to HomePage on successful signup
  void navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  // navigate to LoginPage on signup failure
  void navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // show error dialog
  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // validate email format
  bool isEmailValid(String email) {
    String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }

  // sign up method
  Future<void> signUpUser(BuildContext context) async {
    try {
      if (emailController.text.trim().isEmpty ||
          passwordController.text.isEmpty) {
        showErrorDialog(context, 'Please enter both email and password.');
        return;
      }

      if (!isEmailValid(emailController.text.trim())) {
        showErrorDialog(context, 'Please enter a valid email address.');
        return;
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      // If sign up is successful, navigate to the homepage
      navigateToHome(context);
      print("User signed up: ${userCredential.user?.email}");
    } catch (e) {
      // Handle sign up errors
      print("Error during sign up: $e");
      showErrorDialog(
          context, 'Sign up failed. Please check your email and password.');
      // If signup fails, navigate to the login page
      navigateToLogin(context);
    }
  }

  // sign up with Google method
  Future<void> signUpWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // If sign up with Google is successful, navigate to the homepage
      navigateToHome(context);
      print("User signed up with Google: ${userCredential.user?.displayName}");
    } catch (e) {
      // Handle sign up errors
      print("Error during Google sign up: $e");
      showErrorDialog(context, 'Sign up with Google failed.');
      // If signup fails, navigate to the login page
      navigateToLogin(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                // Logo
                const Icon(
                  Icons.person_add,
                  size: 100,
                ),
                const SizedBox(height: 50),
                // Create an account message
                Text(
                  'Create an account to get started!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                // Email
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                // Password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                // Sign up button
                MyButton2(
                  onTap: () => signUpUser(context),
                ),
                const SizedBox(height: 25),
                // Or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25.0),
                // Google
                GestureDetector(
                  onTap: () => signUpWithGoogle(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/images/google.png',
                        height: 72,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                // Already a member? Login now
                GestureDetector(
                  onTap: () {
                    navigateToLogin(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already a member?'),
                      const SizedBox(width: 4),
                      Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
