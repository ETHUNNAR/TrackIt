import 'package:flutter/material.dart';
import 'package:flutter_learning/data/constrants.dart';
import 'package:flutter_learning/data/notifiers.dart';
import 'package:flutter_learning/views/pages/home__page.dart';
import 'package:flutter_learning/views/pages/profile_page.dart';
import 'package:flutter_learning/views/pages/receipt_page.dart';
import 'package:flutter_learning/views/pages/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/navbar_widgets.dart';

List<Widget> pages = [
  HomePage(),
  ReceiptPage(),
  ProfilePage(),
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TrackIt'),
        actions: [
          IconButton(
            onPressed: () async {
              isDarkModeNotifier.value =
                  !isDarkModeNotifier.value;
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.setBool(
                KConstants.themeModeKey,
                isDarkModeNotifier.value,
              );
            },
            icon: ValueListenableBuilder(
              valueListenable: isDarkModeNotifier,
              builder: (
                context,
                isDarkMode,
                child,
              ) {
                return Icon(
                  isDarkMode
                      ? Icons.dark_mode
                      : Icons.light_mode,
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SettingsPage(
                      title: 'Settings',
                    );
                  },
                ),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: NavbarWidgets(),
    );
  }
}
