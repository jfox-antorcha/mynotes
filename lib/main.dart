import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/view/app/create_update_note_view.dart';
import 'package:mynotes/view/app/notes_main.dart';
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
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      notesRoute: (context) => const NotesView(),
      createUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user == null) return const LoginView();
            if (!user.isEmailVerified) return const VerifyEmailView();
            return const NotesView();
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
