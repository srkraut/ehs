// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehs/app/home/drawer/account_page.dart';
import 'package:ehs/app/home/drawer/my_families.dart';
import 'package:ehs/app/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class FamilyDetails extends StatefulWidget {
  FamilyDetails({Key? key, this.familyDetails}) : super(key: key);
  var familyDetails;

  @override
  State<FamilyDetails> createState() => _FamilyDetailsState();
}

class _FamilyDetailsState extends State<FamilyDetails> {
  final textController = TextEditingController();
  final textControllerTask = TextEditingController();
  DateTime currentDate = DateTime.now();
  bool _isDateSelected = false;
  List<dynamic> _notes = [];

  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  _onSubmit() {
    firestoreInstance
        .collection("users")
        .doc(firebaseUser!.uid)
        .collection("family-note")
        .doc(widget.familyDetails['familyID'])
        .collection("notes")
        .add({
      'note': textController.text,
    });
    firestoreInstance
        .collection("users")
        .doc(firebaseUser!.uid)
        .collection("family-note")
        .doc(widget.familyDetails['familyID'])
        .collection("tasks")
        .add({
      'date': DateFormat('EEEEEE, M/d/y').format(currentDate),
      'task': textControllerTask.text,
    });
    textController.clear();
    textControllerTask.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        (route) => false);
  }

  @override
  void initState() {
    super.initState();
    _getDetails();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  _launchUrl(String url) async {
    await launch(url);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2021, 1, 1),
      lastDate: DateTime(2030, 1, 1),
      helpText: "Choose Your Date",
      confirmText: 'Choose Now',
      cancelText: 'Later',
    );
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;

        _isDateSelected = true;
      });
    }
  }

  Future<List> _getDetails() async {
    final value = FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser?.uid)
        .collection('family-note')
        .doc(widget.familyDetails['familyID'])
        .collection('notes')
        .get();
    _notes =
        await value.then((value) => value.docs.map((e) => e.data()).toList());
    setState(() {});

    return _notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: AccountPage(),
      ),
      appBar: AppBar(
        title: Text(widget.familyDetails['name'] ?? 'Family Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('Family Case No: '),
                        Text(widget.familyDetails['case'] ?? 'Family Case No'),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        const Text('Family Surname: '),
                        Text(widget.familyDetails['name'] ?? 'Family Name'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Add notes:',
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: textController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Add task:',
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(top: 9, left: 10),
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.93,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Text(_isDateSelected
                      ? DateFormat('EEEEEE, M/d/y').format(currentDate)
                      : 'Select a Date'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: textControllerTask,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Task',
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
                ),
                onPressed: _onSubmit,
                child: const Text('Save'),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Contact Family:'),
              ListTile(
                onTap: () => _launchUrl('tel:${widget.familyDetails['phone']}'),
                dense: true,
                minLeadingWidth: 5,
                contentPadding: const EdgeInsets.all(0),
                horizontalTitleGap: 15,
                leading: const Icon(Icons.phone),
                title: const Text('Call'),
              ),
              ListTile(
                onTap: () =>
                    _launchUrl('mailto:${widget.familyDetails['phone']}'),
                dense: true,
                minLeadingWidth: 5,
                contentPadding: const EdgeInsets.all(0),
                horizontalTitleGap: 15,
                leading: const Icon(Icons.email),
                title: const Text('Email'),
              ),
              ListTile(
                onTap: () => _launchUrl('sms:${widget.familyDetails['phone']}'),
                dense: true,
                minLeadingWidth: 5,
                contentPadding: const EdgeInsets.all(0),
                horizontalTitleGap: 15,
                leading: const Icon(Icons.chat),
                title: const Text('Text'),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _notes.length,
                itemBuilder: (context, index) => Card(
                  elevation: 0,
                  color: Colors.grey[200],
                  child: ListTile(
                    title: Text(_notes[index]['note']),
                    trailing: IconButton(
                        onPressed: () async {
                          final _docRef = await FirebaseFirestore.instance
                              .collection("users")
                              .doc(firebaseUser?.uid)
                              .collection('family-note')
                              .doc(widget.familyDetails['familyID'])
                              .collection('notes')
                              .get();

                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(firebaseUser!.uid)
                              .collection('family-note')
                              .doc(widget.familyDetails['familyID'])
                              .collection('notes')
                              .doc(_docRef.docs[index].id)
                              .delete()
                              .then((_) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const MyFamilies()),
                                (route) => false);
                          });
                        },
                        icon: const Icon(Icons.delete)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
