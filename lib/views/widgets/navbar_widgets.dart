import 'package:flutter/material.dart';
import 'package:flutter_learning/data/notifiers.dart';

class NavbarWidgets extends StatelessWidget {
  const NavbarWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.receipt_long_rounded,
              ),
              label: 'Receipts',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          onDestinationSelected: (int value) {
            selectedPageNotifier.value = value;
            debugPrint(
              'Selected page: $value',
            ); // Use debugPrint instead of print
          },
          selectedIndex: selectedPage,
        );
      },
    );
  }
}
