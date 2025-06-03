import 'package:flutter/material.dart';
import 'package:flutter_learning/app/mobile/auth_service.dart';
import 'package:flutter_learning/views/widget_tree.dart';
import 'package:flutter_learning/views/pages/welcome_page.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    this.pageIfnotLoggedIn,
  });

  final Widget? pageIfnotLoggedIn;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            print(
              'Auth state: ${snapshot.data}',
            ); // Debug log
            Widget widget;
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              widget = const Center(
                child:
                    CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              widget =
                  const WidgetTree(); // Navigate to WidgetTree
            } else {
              widget =
                  pageIfnotLoggedIn ??
                  const WelcomePage();
            }
            return widget;
          },
        );
      },
    );
  }
}
