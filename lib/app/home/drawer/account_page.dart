// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehs/app/home/drawer/feedback_page.dart';
import 'package:ehs/app/home/drawer/my_families.dart';
import 'package:ehs/app/home/drawer/privacy_policy_page.dart';
import 'package:ehs/app/home/drawer/support_page.dart';
import 'package:ehs/app/home/drawer/survey_page.dart';
import 'package:ehs/app/home/drawer/terms_condition_page.dart';
import 'package:ehs/app/home/drawer/training_resource_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ehs/app/top_level_providers.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:ehs/constants/keys.dart';
import 'package:ehs/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';

import '../home_page.dart';
import 'expenses_page.dart';
import 'timesheets_page.dart';

class AccountPage extends ConsumerWidget {
  AccountPage({Key? key}) : super(key: key);

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

  late String name;

  Widget buildListTile(IconData? icon, String? title, Function()? onTap) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
      leading: Icon(icon, color: Colors.black),
      title: Text(title!),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    //final user = firebaseAuth.currentUser!;
    var height = MediaQuery.of(context).size.height;

    return ListView(
      children: <Widget>[
        DrawerHeader(
          child: Column(
            children: [
              CircleAvatar(
                radius: height * 0.06,
                child: FutureBuilder(
                  future: _name(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const CircularProgressIndicator();
                    }
                    return Text(
                      name.substring(0, 1),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.04,
                      ),
                    );
                  },
                ),
                backgroundColor: Colors.red.shade400,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: FutureBuilder(
                  future: _name(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const CircularProgressIndicator();
                    }
                    return Text(name);
                  },
                ),
              ),
            ],
          ),
          decoration: const BoxDecoration(
            color: Keys.pColor,
          ),
        ),
        buildListTile(Icons.home, 'Home', () => HomePage.show(context)),
        buildListTile(
          Icons.family_restroom,
          'My Families',
          () => MyFamilies.show(context),
        ),
        buildListTile(
          Icons.local_atm,
          'Expenses',
          () => Expenses.show(context),
        ),
        buildListTile(
          Icons.schedule,
          'Timesheet',
          () => TimeSheet.show(context),
        ),
        buildListTile(Icons.model_training, 'Training resources',
            () => TrainingResource.show(context)),
        const Divider(
          height: 5,
          color: Colors.black,
        ),
        buildListTile(Icons.description, 'Terms and Condtion',
            () => TermsAndConditions.show(context)),
        buildListTile(Icons.privacy_tip, 'Privacy Policy',
            () => PrivacyPolicy.show(context)),
        buildListTile(
            Icons.chat_bubble, 'Feedback', () => FeedbackPage.show(context)),
        buildListTile(Icons.info, 'Support', () => SupportPage.show(context)),
        buildListTile(
          Icons.poll,
          'Survey',
          () => Survey.show(context),
        ),
        buildListTile(
          Icons.logout,
          'Logout',
          () => _confirmSignOut(context, firebaseAuth),
        ),
      ],
    );
  }

  _name() async {
    final firebaseUser = FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then((ds) {
      name = ds.data()!['user'];
    });
  }
}
