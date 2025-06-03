import 'package:flutter/material.dart';
import 'package:flutter_learning/app/mobile/auth_layout.dart';
import 'package:flutter_learning/data/constrants.dart';
import 'package:flutter_learning/data/notifiers.dart';
import 'package:flutter_learning/views/pages/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initThemeMode();
    super.initState();
  }

  void initThemeMode() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();
    final bool? repeat = prefs.getBool(
      KConstants.themeModeKey,
    );
    isDarkModeNotifier.value = repeat ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness:
                  isDarkMode
                      ? Brightness.light
                      : Brightness.dark,
            ),
          ),
          home: AuthLayout(
            pageIfnotLoggedIn:
                const WelcomePage(),
          ),
        );
      },
    );
  }
}
