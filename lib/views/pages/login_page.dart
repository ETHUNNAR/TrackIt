import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning/app/mobile/auth_service.dart';
import 'package:flutter_learning/views/pages/reset_password_page.dart';
import 'package:flutter_learning/views/widget_tree.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controllerEmail =
      TextEditingController();
  TextEditingController controllerPw =
      TextEditingController();
  String errorMessage = '';

  void login() async {
    try {
      await authService.value.signIn(
        email: controllerEmail.text.trim(),
        password: controllerPw.text.trim(),
      );
      setState(() {
        errorMessage =
            ''; // Clear error message on success
      });
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => const WidgetTree(),
          ),
        );
      } // Navigate to the home page or another screen
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage =
            e.message ?? 'There is an error';
      });
    }
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: LayoutBuilder(
              builder: (
                context,
                BoxConstraints constraints,
              ) {
                return FractionallySizedBox(
                  widthFactor:
                      constraints.maxWidth > 500
                          ? 0.5
                          : 1.0,
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lotties/welcome.json',
                        height: 400,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller:
                            controllerEmail,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  15,
                                ),
                          ),
                        ),
                        onEditingComplete: () {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: controllerPw,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  15,
                                ),
                          ),
                        ),
                        onEditingComplete: () {
                          setState(() {});
                        },
                      ),
                      Text(
                        errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (
                                    context,
                                  ) => const ResetPasswordPage(
                                    title:
                                        'Reset Password',
                                  ),
                            ),
                          );
                        },
                        child: Text(
                          'Reset Password',
                        ),
                      ),
                      SizedBox(height: 20),
                      FilledButton(
                        onPressed: () {
                          login();
                        },
                        style:
                            ElevatedButton.styleFrom(
                              minimumSize: Size(
                                double.infinity,
                                40,
                              ),
                            ),
                        child: Text(widget.title),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
