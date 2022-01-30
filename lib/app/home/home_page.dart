// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehs/routing/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'drawer/account_page.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
    this.index,
  }) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  var index;
  static Future<void> show(BuildContext context) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.homePage,
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<dynamic> familyList = [];
  List<dynamic> familydetailList = [];
  List<dynamic> _notes = [];

  @override
  void initState() {
    super.initState();
    _fetch();
    getCurrentUser();
    // getFamilyDetails();
  }

  String? currentUserUID;
  void getCurrentUser() {
    currentUserUID = auth.currentUser?.uid;
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
            });
          }
        });
      }
    }

    if (familydetailList.isNotEmpty) {
      for (var j = 0; j < familydetailList.length; j++) {
        final value = FirebaseFirestore.instance
            .collection("users")
            .doc(currentUserUID)
            .collection('family-note')
            .doc(familydetailList[j]['familyID'])
            .collection('tasks')
            .get();
        _notes = await value
            .then((value) => value.docs.map((e) => e.data()).toList());
        return _notes;
      }
    }
    return _notes;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Home'),
          centerTitle: true,
        ),
        drawer: Drawer(
          backgroundColor: Colors.grey,
          child: AccountPage(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.06,
                  ),
                  Image.asset(
                    'assets/ESP-Logo_draft4.png',
                    height: 100,
                    width: 200,
                    fit: BoxFit.fitWidth,
                  ),
                  Text("Welcome $currentUser"),
                  SizedBox(
                    height: height * 0.06,
                  ),
                ],
              ),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 18.0),
                    child: Text(
                      'Upcoming Tasks',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future: getFamilyDetails(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 0,
                            color: Colors.grey[200],
                            child: ListTile(
                              title: Text(snapshot.data[index]['task']),
                              trailing: Text(snapshot.data[index]['date']),
                              // trailing: IconButton(
                              //     onPressed: () async {
                              //       // await FirebaseFirestore.instance
                              //       //     .collection("users")
                              //       //     .doc(currentUserUID)
                              //       //     .collection('family-note')
                              //       //     .doc(snapshot.data[index]['familyID'])
                              //       //     .collection('notes')
                              //       //     .doc(snapshot.data[index]['id'])
                              //       //     .delete();
                              //       // setState(() {});
                              //     },
                              //     icon: const Icon(Icons.delete)),
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
            ],
          ),
        ),
      ),
    );
  }

  void _fetch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final userData =
        await firestore.collection('users').doc(firebaseUser!.uid).get();
    setState(() {
      currentUser = userData.data()!['user'];
    });
  }
}
