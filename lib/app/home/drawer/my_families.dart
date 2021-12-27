import 'package:ehs/routing/app_router.dart';
import 'package:flutter/material.dart';

import 'account_page.dart';

class MyFamilies extends StatelessWidget {
  const MyFamilies({Key? key}) : super(key: key);
  static Future<void> show(BuildContext context) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.familiesPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.grey,
        child: AccountPage(),
      ),
      appBar: AppBar(
        title: const Text('My Families'),
      ),
      body: const Center(
        child: Text('My Families'),
      ),
    );
  }
}
