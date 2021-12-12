import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ehs/app/top_level_providers.dart';
import 'package:ehs/common_widgets/avatar.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:ehs/constants/keys.dart';
import 'package:ehs/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';

class AccountPage extends ConsumerWidget {
  Future<void> _signOut(BuildContext context, FirebaseAuth firebaseAuth) async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: Strings.logoutFailed,
        exception: e,
      ));
    }
  }

  Future<void> _confirmSignOut(
      BuildContext context, FirebaseAuth firebaseAuth) async {
    final bool didRequestSignOut = await showAlertDialog(
          context: context,
          title: Strings.logout,
          content: Strings.logoutAreYouSure,
          cancelActionText: Strings.cancel,
          defaultActionText: Strings.logout,
        ) ??
        false;
    if (didRequestSignOut == true) {
      await _signOut(context, firebaseAuth);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    final user = firebaseAuth.currentUser!;
    var height = MediaQuery.of(context).size.height;
    var name = 'John Doe';
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text(Strings.accountPage),
    //     actions: <Widget>[
    //       TextButton(
    //         key: const Key(Keys.logout),
    //         child: const Text(
    //           Strings.logout,
    //           style: TextStyle(
    //             fontSize: 18.0,
    //             color: Colors.white,
    //           ),
    //         ),
    //         onPressed: () => _confirmSignOut(context, firebaseAuth),
    //       ),
    //     ],
    //     bottom: PreferredSize(
    //       preferredSize: const Size.fromHeight(130.0),
    //       child: _buildUserInfo(user),
    //     ),
    //   ),
    // );

    return ListView(
      children: <Widget>[
        DrawerHeader(
          child: Column(
            children: [
              CircleAvatar(
                radius: height * 0.06,
                child: Text(
                  name.substring(0, 1),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.04,
                  ),
                ),
                backgroundColor: Colors.red.shade400,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(name),
              ),
            ],
          ),
          decoration: const BoxDecoration(
            color: Keys.pColor,
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.home,
            color: Colors.black,
          ),
          title: const Text('Home'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.family_restroom,
            color: Colors.black,
          ),
          title: const Text('My Families'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.local_atm,
            color: Colors.black,
          ),
          title: const Text('Expenses'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.schedule,
            color: Colors.black,
          ),
          title: const Text('Timesheets'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        const Divider(
          height: 5,
          color: Colors.black,
        ),
        ListTile(
          leading: const Icon(
            Icons.description,
            color: Colors.black,
          ),
          title: const Text('Terms and Conditions'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.privacy_tip,
            color: Colors.black,
          ),
          title: const Text('Privacy Policy'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.chat_bubble,
            color: Colors.black,
          ),
          title: const Text('Feedback'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.info,
            color: Colors.black,
          ),
          title: const Text('Support'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.logout,
            color: Colors.black,
          ),
          title: const Text('Logout'),
          onTap: () => _confirmSignOut(context, firebaseAuth),
        ),
      ],
    );
  }

  Widget _buildUserInfo(User user) {
    return Column(
      children: [
        Avatar(
          photoUrl: user.photoURL,
          radius: 50,
          borderColor: Colors.black54,
          borderWidth: 2.0,
        ),
        const SizedBox(height: 8),
        if (user.displayName != null)
          Text(
            user.displayName!,
            style: const TextStyle(color: Colors.white),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
