import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehs/constants/keys.dart';
import 'package:ehs/routing/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_sheet/widget/sheet.dart';
import 'package:time_picker_sheet/widget/time_picker.dart';
import 'package:tuple/tuple.dart';

import 'account_page.dart';

class TimeSheet extends StatefulWidget {
  const TimeSheet({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.timesheets,
    );
  }

  @override
  _TimeSheetState createState() => _TimeSheetState();
}

class _TimeSheetState extends State<TimeSheet> {
  List projhashMap = [];
  Map<String, dynamic> submitmap =    <String, dynamic>{};

  //Connceting to the fire base
  DateTime dateTimeSelected = DateTime.now(); //for project 1
  DateTime acmeSelected = DateTime.now(); //for acme
  DateTime vaccationSelected = DateTime.now(); //for vaccation
  DateTime officeSelected = DateTime.now(); //for office
  DateTime breakSelected = DateTime.now(); //for break
  bool _isDateSelected = false;
  DateTime currentDate = DateTime.now();
  DateTime newTask = DateTime.now(); //for date picker

  String? selectedDate, ProjectTime, Acme, Vaccation, Office, Break;

  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  void _onSubmit() {
    submitmap.putIfAbsent("Date", () => DateFormat('EEEEEE, M/d/y').format(currentDate).toString());
    submitmap.putIfAbsent("Acme", () => '${acmeSelected.hour.toString()} : ${acmeSelected.minute.toString()}'.toString());
    submitmap.putIfAbsent("ProjectTime", () => '${dateTimeSelected.hour.toString()} : ${dateTimeSelected.minute.toString()}');
    submitmap.putIfAbsent("Vaccation", () => '${vaccationSelected.hour.toString()} : ${vaccationSelected.minute.toString()}');
    submitmap.putIfAbsent("Office", () => '${officeSelected.hour.toString()} : ${officeSelected.minute.toString()}');
    submitmap.putIfAbsent("Break", () => '${breakSelected.hour.toString()} : ${breakSelected.minute.toString()}');

   if(projhashMap.length>0){
     for(int i=0 ; i<projhashMap.length ; i++){
       Tuple2 temp = projhashMap[i];
       submitmap.putIfAbsent(temp.item1.toString(), () => temp.item2.toString());
     }
   }

    // var encodedObject = json.encode(submitmap);

    firestoreInstance
        .collection("users")
        .doc(firebaseUser!.uid)
        .collection("Timesheet")
        .add(submitmap);
  }

  //For project 1 Time picker Function
  bool isSheetSelect = false;

  void _openTimePickerSheet(BuildContext context) async {
    final result = await TimePicker.show<DateTime?>(
      context: context,
      sheet: TimePickerSheet(
        sheetTitle: 'Select a time schedule',
        minuteTitle: 'Minute',
        hourTitle: 'Hour',
        saveButtonText: 'Save',
      ),
    );

    if (result != null && result != dateTimeSelected) {
      setState(() {
        dateTimeSelected = result;
        isSheetSelect = true;
      });
    }
  }

  //For Acme time picker function

  bool isAcmeSelect = false;

  void _openAcmePickerSheet(BuildContext context) async {
    final result = await TimePicker.show<DateTime?>(
      context: context,
      sheet: TimePickerSheet(
        sheetTitle: 'Select a time schedule',
        minuteTitle: 'Minute',
        hourTitle: 'Hour',
        saveButtonText: 'Save',
      ),
    );

    if (result != null && result != acmeSelected) {
      setState(() {
        acmeSelected = result;
        isAcmeSelect = true;
      });
    }
  }

  //new task
  bool isNewTaskSelect = false;

  void _newTaskSheet(BuildContext context, setState) async {
    final result = await TimePicker.show<DateTime?>(
      context: context,
      sheet: TimePickerSheet(
        sheetTitle: 'Select a time schedule',
        minuteTitle: 'Minute',
        hourTitle: 'Hour',
        saveButtonText: 'Save',
      ),
    );

    if (result != null && result != newTask) {
      setState(() {
        newTask = result;
        isNewTaskSelect = true;
      });
    }
  }

  bool isvaccationSelect = false;

  void _vaccationSheet(BuildContext context) async {
    final result = await TimePicker.show<DateTime?>(
      context: context,
      sheet: TimePickerSheet(
        sheetTitle: 'Select a time schedule',
        minuteTitle: 'Minute',
        hourTitle: 'Hour',
        saveButtonText: 'Save',
      ),
    );

    if (result != null && result != vaccationSelected) {
      setState(() {
        vaccationSelected = result;
        isvaccationSelect = true;
      });
    }
  }

  //for office Time picker Function

  bool isOfficeSelect = false;

  void _officeSheet(BuildContext context) async {
    final result = await TimePicker.show<DateTime?>(
      context: context,
      sheet: TimePickerSheet(
        sheetTitle: 'Select a time schedule',
        minuteTitle: 'Minute',
        hourTitle: 'Hour',
        saveButtonText: 'Save',
      ),
    );

    if (result != null && result != officeSelected) {
      setState(() {
        officeSelected = result;
        isOfficeSelect = true;
      });
    }
  }

  //for break time picker function

  bool isBreakSelect = false;

  void _breakSheet(BuildContext context) async {
    final result = await TimePicker.show<DateTime?>(
      context: context,
      sheet: TimePickerSheet(
        sheetTitle: 'Select a time schedule',
        minuteTitle: 'Minute',
        hourTitle: 'Hour',
        saveButtonText: 'Save',
      ),
    );

    if (result != null && result != breakSelected) {
      setState(() {
        breakSelected = result;
        isBreakSelect = true;
      });
    }
  }

//Date picker Functions

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

  //text editing controller
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void click() {
    Navigator.of(context).pop();
  }

//widget build function
  @override
  Widget build(BuildContext context) {
    List<Widget> widg = [
      Row(
        children: [
          const Icon(Icons.calendar_today),
          const SizedBox(width: 14),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Text(_isDateSelected
                      ? DateFormat('EEEEEE, M/d/y').format(currentDate)
                      : '  Select your Day'),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 18),
      Row(
        children: [
          const Text("Project 1"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      _openTimePickerSheet(context);
                    },
                    child: Text(isSheetSelect
                        ? '${dateTimeSelected.hour.toString()} : ${dateTimeSelected.minute.toString()}'
                        : '  Select your Time'),
                  ),
                  const SizedBox(width: 14),
                  const Icon(Icons.timer)
                ],
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 14,
      ),
      Row(
        children: [
          const Text("ACME"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      _openAcmePickerSheet(context);
                    },
                    child: Text(isAcmeSelect
                        ? '${acmeSelected.hour.toString()} : ${acmeSelected.minute.toString()}'
                        : '  Select your Time'),
                  ),
                  const SizedBox(width: 14),
                  const Icon(Icons.timer)
                ],
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 14,
      ),
      Row(
        children: [
          const Text("Vacation"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      _vaccationSheet(context);
                    },
                    child: Text(isvaccationSelect
                        ? '${vaccationSelected.hour.toString()} : ${vaccationSelected.minute.toString()}'
                        : '  Select your Time'),
                  ),
                  const SizedBox(width: 14),
                  const Icon(Icons.timer)
                ],
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 14,
      ),
      Row(
        children: [
          const Text("Office"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      _officeSheet(context);
                    },
                    child: Text(isOfficeSelect
                        ? '${officeSelected.hour.toString()} : ${officeSelected.minute.toString()}'
                        : '  Select your Time'),
                  ),
                  const SizedBox(width: 14),
                  const Icon(Icons.timer)
                ],
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 14,
      ),
      Row(
        children: [
          Text("Break"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      _breakSheet(context);
                    },
                    child: Text(isBreakSelect
                        ? '${breakSelected.hour.toString()} : ${breakSelected.minute.toString()}'
                        : '  Select your Time'),
                  ),
                  const SizedBox(width: 14),
                  const Icon(Icons.timer)
                ],
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      projhashMap.length > 0
          ? ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: projhashMap.length,
              itemBuilder: (BuildContext context, int index) {
                Tuple2 temp = projhashMap[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: Row(
                    children: [
                      Text(temp.item1.toString()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                          ),
                          child: Row(
                            children: [
                              Text(temp.item2.toString()),
                              const SizedBox(width: 14),
                              const Icon(Icons.timer)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
          : const Text(""),
    ];
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.grey,
        child: AccountPage(),
      ),
      appBar: AppBar(
        title: const Text("Timesheet"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text("Please select a day and Enter the duration"),
              const SizedBox(
                height: 20,
              ),
              ...widg,
              const SizedBox(height: 14),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Keys.pColor),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: StatefulBuilder(
                              builder: (context, StateSetter setState) {
                            return Container(
                              height: 150,
                              child: Scaffold(
                                body: Column(children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        hintText: "Next Task",
                                      ),
                                      controller: _controller,
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            _newTaskSheet(context, setState);
                                          },
                                          child: Text(isNewTaskSelect
                                              ? '${newTask.hour.toString()} : ${newTask.minute.toString()}'
                                              : ' Select your Time'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                      child: ElevatedButton(
                                          onPressed: () => setState(() {
                                                projhashMap.add(
                                                    Tuple2<String, String>(
                                                        _controller.text,
                                                        newTask.hour
                                                                .toString() +
                                                            ":" +
                                                            newTask.minute
                                                                .toString()));
                                                Navigator.of(context).pop();
                                              }),
                                          child: Text('Click')))
                                ]),
                              ),
                            );
                          }),
                        );
                      });
                },
                child: const Text(
                  'Add Project',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Keys.pColor),
                ),
                onPressed: _onSubmit,
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
