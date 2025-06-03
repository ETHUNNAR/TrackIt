import 'package:flutter/material.dart';
import 'package:flutter_learning/views/pages/register_page.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Text(
              'Onboarding Page',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(
                  20.0,
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lotties/welcome.json',
                      height: 400,
                    ),
                    SizedBox(height: 20),

                    SizedBox(height: 10),

                    SizedBox(height: 20),
                    FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return RegisterPage(
                                title: 'Register',
                              );
                            },
                          ),
                        );
                      },
                      style:
                          ElevatedButton.styleFrom(
                            minimumSize: Size(
                              double.infinity,
                              40,
                            ),
                          ),
                      child: Text('Next'),
                    ),

                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
