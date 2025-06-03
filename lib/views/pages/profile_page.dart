import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning/app/mobile/auth_service.dart';
import 'package:flutter_learning/data/notifiers.dart';
import 'package:flutter_learning/views/pages/update_username_page.dart';
import 'package:flutter_learning/views/pages/welcome_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    debugPrint('ProfilePage loaded');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    if (state == AppLifecycleState.resumed) {
      // Refresh data when returning to this page
      debugPrint('ProfilePage resumed');
      setState(() {
        // Add logic to refresh data here
      });
    }
  }

  void signout(BuildContext context) async {
    try {
      await authService.value.signOut();
      selectedPageNotifier.value =
          0; // Reset selected page to 0
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder:
                (context) => const WelcomePage(),
          ),
          (route) => false,
        );
      }
    } on FirebaseException catch (e) {
      print('Error signing out: ${e.message}');
    }
  }

  void changePassword() {
    debugPrint('Change password clicked');
  }

  void deleteAccount() {
    debugPrint('Delete account clicked');
  }

  void aboutApp() {
    debugPrint('About this app clicked');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: const AssetImage(
              'assets/images/background.jpg',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome, ${authService.value.currentUser!.displayName ?? 'User'}',
            style:
                Theme.of(
                  context,
                ).textTheme.bodyLarge,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Settings',
              style:
                  Theme.of(
                    context,
                  ).textTheme.headlineMedium,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          const UpdateUsernamePage(
                            title:
                                'Update Username',
                          ),
                ),
              ).then((_) {
                // Refresh data when returning from UpdateUsernamePage
                setState(() {
                  debugPrint(
                    'Returned to ProfilePage',
                  );
                });
              });
            },
            style: TextButton.styleFrom(
              minimumSize: const Size(
                double.infinity,
                50,
              ),
              alignment: Alignment.centerLeft,
            ),
            child: const Text('Update username'),
          ),
          TextButton(
            onPressed: changePassword,
            style: TextButton.styleFrom(
              minimumSize: const Size(
                double.infinity,
                50,
              ),
              alignment: Alignment.centerLeft,
            ),
            child: const Text('Change password'),
          ),
          TextButton(
            onPressed: deleteAccount,
            style: TextButton.styleFrom(
              minimumSize: const Size(
                double.infinity,
                50,
              ),
              alignment: Alignment.centerLeft,
            ),
            child: const Text(
              'Delete my account',
            ),
          ),
          TextButton(
            onPressed: aboutApp,
            style: TextButton.styleFrom(
              minimumSize: const Size(
                double.infinity,
                50,
              ),
              alignment: Alignment.centerLeft,
            ),
            child: const Text('About this app'),
          ),
          TextButton.icon(
            onPressed: () => signout(context),
            style: TextButton.styleFrom(
              minimumSize: const Size(
                double.infinity,
                50,
              ),
              alignment: Alignment.centerLeft,
              foregroundColor: Colors.red,
            ),
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            label: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
