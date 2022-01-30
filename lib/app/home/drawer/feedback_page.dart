// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehs/constants/keys.dart';
import 'package:ehs/routing/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';
import 'account_page.dart';

class FeedbackPage extends StatelessWidget {
  FeedbackPage({Key? key}) : super(key: key);

  final textName = TextEditingController();
  final textFeedback = TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  // final FocusScopeNode _node = FocusScopeNode();

  static Future<void> show(
    BuildContext context,
  ) async {
    await Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        AppRoutes.feedback, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    void _onSubmit() {
      firestoreInstance
          .collection("users")
          .doc(firebaseUser!.uid)
          .collection("feedback")
          .add({
        "name": textName.text,
        "feedback": textFeedback.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Form Submitted"),
        duration: Duration(milliseconds: 500),
      ));
      // HomePage.show(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          (route) => false);
    }

    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.grey,
        child: AccountPage(),
      ),
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name:'),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: textName,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Name',
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text('Your feedback:'),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: textFeedback,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your feedback',
                ),
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Keys.pColor),
              ),
              onPressed: _onSubmit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
