import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehs/constants/keys.dart';
import 'package:ehs/routing/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ehs/app/home/cupertino_home_scaffold.dart';
import 'package:ehs/app/home/entries/entries_page.dart';
import 'package:ehs/app/home/jobs/jobs_page.dart';
import 'package:ehs/app/home/tab_item.dart';
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
  late String MyName;


  FirebaseFirestore firestore = FirebaseFirestore.instance;



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
        drawer:  Drawer(
          backgroundColor: Colors.grey,
          child: AccountPage(),
        ),
        body: Column(
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
                FutureBuilder(
                  future: _fetch(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done)
                      return CircularProgressIndicator();
                    return Text("Welcome $MyName");
                  },
                ),
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
          ],
        ),
      ),
    );
  }
  _fetch() async{
    final firebaseUser = await FirebaseAuth.instance.currentUser!;
    if(firebaseUser !=null) {
      await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then((ds) {
      MyName = ds.data()!['user'];
      print(MyName);
    }).catchError((e){
      print(e);
      });
    }
  }
}


