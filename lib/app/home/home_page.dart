import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehs/constants/keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ehs/app/home/cupertino_home_scaffold.dart';
import 'package:ehs/app/home/entries/entries_page.dart';
import 'package:ehs/app/home/jobs/jobs_page.dart';
import 'package:ehs/app/home/tab_item.dart';

import 'drawer/account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TabItem _currentTab = TabItem.jobs;

  // final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
  //   TabItem.jobs: GlobalKey<NavigatorState>(),
  //   TabItem.entries: GlobalKey<NavigatorState>(),
  //   TabItem.account: GlobalKey<NavigatorState>(),
  // };

  // Map<TabItem, WidgetBuilder> get widgetBuilders {
  //   return {
  //     TabItem.jobs: (_) => JobsPage(),
  //     TabItem.entries: (_) => EntriesPage(),
  //     TabItem.account: (_) => AccountPage(),
  //   };
  // }

  // void _select(TabItem tabItem) {
  //   if (tabItem == _currentTab) {
  //     // pop to first route
  //     navigatorKeys[tabItem]!.currentState?.popUntil((route) => route.isFirst);
  //   } else {
  //     setState(() => _currentTab = tabItem);
  //   }
  // }

  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var user;
    getUser() async {
      await firestoreInstance
          .collection("users")
          .doc(firebaseUser!.uid)
          .get()
          .then((value) => user = value.data()!["user"]);
    }

    // var userName =
    //     firestoreInstance.collection("users").doc(firebaseUser!.uid).get();
    // var name = userName.then((value) => value.data()!["user"]);
    // .then((value) => value.data()!["user"]);

    // print(userName);
    // return WillPopScope(
    //   onWillPop: () async =>
    //       !(await navigatorKeys[_currentTab]!.currentState?.maybePop() ??
    //           false),
    //   child: CupertinoHomeScaffold(
    //     currentTab: _currentTab,
    //     onSelectTab: _select,
    //     widgetBuilders: widgetBuilders,
    //     navigatorKeys: navigatorKeys,
    //   ),
    // );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Home'),
          centerTitle: true,
        ),
        drawer: const Drawer(
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
                Text('     Welcome $user'),
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
}
