import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/view/auth/register.dart';
import 'package:mynotes/view/auth/login.dart';
import 'package:mynotes/view/auth/verify_email.dart';

void main() {
  runApp(MaterialApp(
    title: 'My Notes',
    theme: ThemeData(
      primarySwatch: Colors.cyan,
    ),
    home: const HomePage(),
    routes: {
      '/login': (context) => const LoginView(),
      '/register': (context) => const RegisterView(),
      '/verifyEmail': (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) return const LoginView();
            if (!user.emailVerified) return const VerifyEmailView();
            return const Text('User verified!!!');
          default:
            return const CircularProgressView();
        }
      },
    );
  }
}

class CircularProgressView extends StatelessWidget {
  const CircularProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
