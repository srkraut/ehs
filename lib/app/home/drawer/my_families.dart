import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehs/app/home/jobs/list_items_builder.dart';
import 'package:ehs/routing/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'account_page.dart';

class MyFamilies extends StatefulWidget {
  const MyFamilies({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.familiesPage,
    );
  }

  @override
  State<MyFamilies> createState() => _MyFamiliesState();
}

class _MyFamiliesState extends State<MyFamilies> {
  List<dynamic> familyList = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() {
    getCurrentUser();
    getFamily();
  }

  String? currentUserUID;

  void getCurrentUser() {
    currentUserUID = auth.currentUser?.uid;
  }

  void getFamily() async {
    final value = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserUID)
        .get();

    familyList = value.data()!["Family"];
  }

  Future<Widget> getFamilydetails(String uid) async {
    final value =
        await FirebaseFirestore.instance.collection("Families").doc(uid).get();
    return Text(value.data()!["Case_no"].toString());
  }

  // Future<List<String>> getGroupMembers() async {
  //   final String? uid = auth.currentUser?.uid;
  //   final currentUser = [];
  //   final groups = [];
  //   // Get User document
  //   await firestore
  //       .collection('Families')
  //       .doc(uid)
  //       .get()
  //       .then((DocumentSnapshot snapshot) {
  //     currentUser.add(snapshot.data);
  //   });
  //   // Get groupeId from currentUser Data
  //   final groupId = currentUser[0]['groupId'];
  //
  //   // Get groupe Document
  //   await firestore
  //       .collection('users')
  //       .doc(groupId)
  //       .get()
  //       .then((DocumentSnapshot snapshot) {
  //     groups.add(snapshot.data);
  //   });
  //
  //   return groups[0]['Family'];
  //
  // }

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
        body: ListView.builder(
            itemCount: familyList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Text(familyList[index].toString());
              //  return Text(getFamilydetails("$familyList").toString());
            }));
  }
}
