
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thirdeyeapp/components/my_button.dart';
import 'package:thirdeyeapp/components/my_textfield.dart';
import 'package:thirdeyeapp/pages/profile.dart';
import 'package:thirdeyeapp/pages/signup.dart';
import 'package:thirdeyeapp/pages/spects.dart'; // Import MyHomePage

class LoginPage extends StatefulWidget {
  LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign user in method
  void signUserIn() async {
    try {
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();
      
      // Sign in with email and password
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to home page upon successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(
          
        )), // Navigate to MyHomePage
      );
    } catch (e) {
      // Handle sign-in errors here
      print("Sign in error: $e");

      // Show alert message for incorrect email or password
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sign In Failed"),
            content: Text("Incorrect email or password. Please try again."),
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

  // Navigate to sign up page
  void navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  // Google sign-in method
  void signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;
        print(user);

        // Navigate to home page upon successful sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(
           // Add device ID here or retrieve it from wherever necessary
    ),
  ),
          // Navigate to profilepage
        );
      }
    } catch (error) {
      print(error);
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
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // Welcome back message
                Text(
                  'Welcome back you\'ve been missed!',
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

                const SizedBox(height: 10),
                // Forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Sign in button
                MyButton(
                  onTap: signUserIn,
                ),

                const SizedBox(height: 50),
                // Continue with
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
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 25.0),
                // Google
                GestureDetector(
                  onTap: signInWithGoogle, // Call Google sign-in method
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
                // Not a member? Register now
                GestureDetector(
                  onTap: () {
                    navigateToSignUp(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a member?'),
                      const SizedBox(width: 4),
                      Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
