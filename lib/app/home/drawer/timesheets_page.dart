import 'package:ehs/routing/app_router.dart';
import 'package:flutter/material.dart';

import 'account_page.dart';

class TimeSheet extends StatelessWidget {
  const TimeSheet({Key? key}) : super(key: key);
  static Future<void> show(BuildContext context) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.timesheets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        backgroundColor: Colors.grey,
        child: AccountPage(),
      ),
      appBar: AppBar(
        title: const Text('TimeSheet'),
      ),
      body: const Center(
        child: Text('TimeSheets'),
      ),
    );
  }
}
