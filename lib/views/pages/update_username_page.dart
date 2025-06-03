import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning/app/mobile/auth_service.dart';

class UpdateUsernamePage extends StatefulWidget {
  const UpdateUsernamePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<UpdateUsernamePage> createState() =>
      _UpdateUsernamePageState();
}

class _UpdateUsernamePageState
    extends State<UpdateUsernamePage> {
  TextEditingController controllerUsername =
      TextEditingController();
  String errorMessage = '';

  void updateUsername() async {
    if (controllerUsername.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Username cannot be empty';
      });
      return;
    }

    try {
      await authService.value.UpdateUsername(
        username: controllerUsername.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: const Text(
              'Username updated successfully!',
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
                  Icons.edit,
                  size: 200,
                  color: Colors.teal,
                ),
                const SizedBox(height: 100),
                TextField(
                  controller: controllerUsername,
                  onChanged: (value) {
                    setState(() {
                      // Check if the field is empty and update the error message
                      errorMessage =
                          value.trim().isEmpty
                              ? 'Username cannot be empty' // Show error when empty
                              : ''; // Clear error when not empty
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'New username',
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
                      () => updateUsername(),
                  child: const Text(
                    'Update Username',
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
