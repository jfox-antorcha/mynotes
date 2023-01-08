import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email')),
      body: Center(
        child: Column(children: [
          const Text('Please verify your email address'),
          TextButton(
              onPressed: () async {
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified == false) {
                  await AuthService.firebase().sendEmailVerification();
                }
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (_) => false,
                );
              },
              child: const Text('Send email verification'))
        ]),
      ),
    );
  }
}
