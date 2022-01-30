import 'package:ehs/routing/app_router.dart';
import 'package:flutter/material.dart';

import 'account_page.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);
  static Future<void> show(
    BuildContext context,
  ) async {
    await Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        AppRoutes.privacyPolicy, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.grey,
        child: AccountPage(),
      ),
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const Center(
        child: Text('Privacy Policy'),
      ),
    );
  }
}
