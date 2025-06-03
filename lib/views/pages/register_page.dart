import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning/app/mobile/auth_service.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {
  TextEditingController controllerEmail =
      TextEditingController();
  TextEditingController controllerPw =
      TextEditingController();

  String errorMessage = '';
  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPw.dispose();
    super.dispose();
  }

  void register() async {
    try {
      await authService.value
          .createUserWithEmailAndPassword(
            email: controllerEmail.text.trim(),
            password: controllerPw.text.trim(),
          );
      setState(() {
        errorMessage = 'Registration successful!';
      });
      // Navigate to another page or perform additional actions
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage =
            e.message ?? 'There is an error';
      });
    }
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
                      Text(
                        'Register Page',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
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
                      SizedBox(height: 10),
                      Text(
                        errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 20),
                      FilledButton(
                        onPressed: () {
                          register();
                        },
                        style:
                            FilledButton.styleFrom(
                              minimumSize: Size(
                                double.infinity,
                                40,
                              ),
                            ),
                        child: Text('Register'),
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
