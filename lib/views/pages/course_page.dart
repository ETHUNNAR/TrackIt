import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  _CoursePageState createState() =>
      _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  Map<String, dynamic>? secretData;
  bool isLoading = false;

  Future<void> fetchSecret() async {
    setState(() => isLoading = true);

    final response = await http.get(
      Uri.parse(
        'https://secrets-api.appbrewery.com/random',
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        secretData = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load secret!'),
        ),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Secret Viewer'),
      ),
      body: Center(
        child:
            isLoading
                ? const CircularProgressIndicator()
                : secretData != null
                ? Padding(
                  padding: const EdgeInsets.all(
                    16.0,
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID: ${secretData!["id"]}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Secret: ${secretData!["secret"]}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'EM Score: ${secretData!["emScore"]}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Username: ${secretData!["username"]}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Timestamp: ${secretData!["timestamp"]}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
                : const Text(
                  'Press the button to fetch a secret!',
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchSecret,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

// To run this, make sure to add 'http' package in pubspec.yaml:
// dependencies:
//   http: ^1.1.0

// After that, run `flutter pub get` and launch your app! 🚀
