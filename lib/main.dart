import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_events.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
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
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      createUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) return const NotesView();
        if (state is AuthStateNeedsVerification) return const VerifyEmailView();
        if (state is AuthStateRegistering) return const RegisterView();
        if (state is AuthStateLoggedOut) {
          if (state.isLoading) return const CircularProgressView();
          return const LoginView();
        }
        return const LoginView();
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
