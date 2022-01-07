// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehs/app/home/drawer/family_details.dart';
import 'package:ehs/routing/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  List<dynamic> familydetailList = [];

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
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserUID)
        .get();

    setState(() {});
  }

  Future<List> getFamilyDetails() async {
    final value = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserUID)
        .get();

    try {
      familyList = value.data()!["families"];
    } catch (e) {}

    if (familyList.isNotEmpty) {
      for (var i = 0; i < familyList.length; i++) {
        DocumentReference docRef = FirebaseFirestore.instance
            .doc("Families/" + familyList[i].toString());
        docRef.get().then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            familydetailList.add({
              "familyID": familyList[i],
              "case": documentSnapshot.get('Case_no'),
              "name": documentSnapshot.get('Surname'),
              "phone": documentSnapshot.get('phone'),
              "email": documentSnapshot.get('email'),
            });
          }
        });
      }
    }
    return familydetailList;
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
      body: FutureBuilder(
          future: getFamilyDetails(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => FamilyDetails(
                            familyDetails: snapshot.data[index],
                          ),
                        ),
                        (Route<dynamic> route) => false),
                    child: Card(
                      child: ListTile(
                        title: Text(snapshot.data[index]["name"]),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
