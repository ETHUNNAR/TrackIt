import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning/app/mobile/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<ResetPasswordPage> createState() =>
      _ResetPasswordPageState();
}

class _ResetPasswordPageState
    extends State<ResetPasswordPage> {
  TextEditingController controllerEmail =
      TextEditingController();
  String errorMessage = '';

  void resetPassword() async {
    try {
      await authService.value
          .sendPasswordResetEmail(
            email: controllerEmail.text.trim(),
          );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: const Text(
              'Password reset email sent!',
            ),
            duration: const Duration(seconds: 2),
            backgroundColor:
                Theme.of(
                  context,
                ).colorScheme.primary,
          ),
        );
      }

      setState(() {
        errorMessage = '';
      });
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          errorMessage =
              e.message ?? 'There is an error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_reset,
                  size: 200,
                  color: Colors.teal,
                ),
                const SizedBox(height: 100),
                TextField(
                  controller: controllerEmail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText:
                        errorMessage.isNotEmpty
                            ? errorMessage
                            : null,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                            15,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      () => resetPassword(),
                  child: const Text(
                    'Reset Password',
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
