import 'package:ehs/routing/app_router.dart';
import 'package:flutter/material.dart';

import 'account_page.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  static Future<void> show(
    BuildContext context,
  ) async {
    await Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        AppRoutes.termsAndConditions, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.grey,
        child: AccountPage(),
      ),
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: const Center(
        child: Text('Terms and Conditions'),
      ),
    );
  }
}
