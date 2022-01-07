// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehs/constants/keys.dart';
import 'package:ehs/routing/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../home_page.dart';
import 'account_page.dart';

class Survey extends StatefulWidget {
  const Survey({Key? key}) : super(key: key);

  static Future<void> show(
    BuildContext context,
  ) async {
    await Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        AppRoutes.surveyPage, (Route<dynamic> route) => false);
  }

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  DateTime currentDate = DateTime.now();
  bool _isDateSelected = false;
  final volunteerController = TextEditingController();
  final nameController = TextEditingController();
  final q5COntroller = TextEditingController();
  final q12COntroller = TextEditingController();
  final q14COntroller = TextEditingController();

  String? date, volunteer_no, name, q5, q12, q14;

  List<Map> Q6 = [
    {'value': 'Telephone Call', 'label': false},
    {'value': 'Email', 'label': false},
    {'value': 'Text', 'label': false},
    {'value': 'In person meetup', 'label': false},
    {'value': 'None', 'label': false},
  ];

  List<Map> Q10 = [
    {'value': 'Attempted contacts', 'label': false},
    {'value': 'Successful contacts', 'label': false},
    {'value': 'Outline of contact', 'label': false},
    {'value': 'Have not submitted Case notes', 'label': false},
  ];

  static const valuesQ4 = <String>[
    'Yes',
    'No',
    'No, please give more details in Q5',
  ];
  static const valuesQ7 = <String>[
    '0-1 Hours',
    '1-2 Hours',
    '2+ Hours',
    'None',
  ];
  static const valuesQ8 = <String>[
    'Local Community services(i.e:playgroups,library,craft group)',
    'Additional allied health services(e.g:CPS, SFSK, CAHMS)',
    'Family\'s GP',
    'Other',
  ];
  static const valuesQ9 = <String>[
    'Yes',
    'No',
  ];
  static const valuesQ11 = <String>[
    'Yes',
    'No',
  ];
  static const valuesQ13 = <String>[
    'Yes',
    'No',
  ];
  static const valuesQ15 = <String>[
    'Yes',
    'No',
    'Unsure',
  ];
  String selectedValueQ4 = valuesQ4.first;
  String selectedValueQ7 = valuesQ7.first;
  String selectedValueQ8 = valuesQ8.first;
  String selectedValueQ9 = valuesQ9.first;
  String selectedValueQ11 = valuesQ11.first;
  String selectedValueQ13 = valuesQ13.first;
  String selectedValueQ15 = valuesQ15.first;

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

  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  // final FocusScopeNode _node = FocusScopeNode();

  void _onSubmit() {
    firestoreInstance
        .collection("users")
        .doc(firebaseUser!.uid)
        .collection("Survey")
        .add({
      "q1": DateFormat('EEEEEE, M/d/y').format(currentDate),
      "q2": volunteerController.text,
      "q3": nameController.text,
      "q4": selectedValueQ4,
      "q5": q5COntroller.text,
      "q6": Q6,
      "q7": selectedValueQ7,
      "q8": selectedValueQ8,
      "q9": selectedValueQ9,
      "q10": Q10,
      "q11": selectedValueQ11,
      "q12": q12COntroller.text,
      "q13": selectedValueQ13,
      "q14": q14COntroller.text,
      "q15": selectedValueQ15,
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

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    volunteerController.dispose();
    q5COntroller.dispose();
    q12COntroller.dispose();
    q14COntroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: Colors.grey,
          child: AccountPage(),
        ),
        appBar: AppBar(
          title: const Text('Survey'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Volunteer Survey', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 14),
                const Text(
                  '1. Date of Submission',
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Text(_isDateSelected
                            ? DateFormat('M/d/y').format(currentDate)
                            : 'Please input date (MM/DD/YYYY)'),
                      ),
                      const Icon(Icons.date_range),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text('2. Your Volunteer No.'),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.only(top: 9, left: 10),
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: volunteerController,
                    onSubmitted: (value) => setState(() {
                      volunteer_no = value;
                    }),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your answer',
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('3. Your Name'),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.only(top: 9, left: 10),
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: TextField(
                    controller: nameController,
                    onSubmitted: (value) => setState(() {
                      name = value;
                    }),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your answer',
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                    '4. Have you been in contact with your family in the past 2 weeks?'),
                const SizedBox(height: 8),
                Column(
                  children: valuesQ4.map(
                    (value) {
                      selectedValueQ4 == value;

                      return RadioListTile<String>(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        value: value,
                        groupValue: selectedValueQ4,
                        title: Text(
                          value,
                        ),
                        onChanged: (value) =>
                            setState(() => selectedValueQ4 = value!),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: 14),
                const Text(
                    '5. If you answered no to Question 4, please explain in more detail why you have not contacted the family'),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: q5COntroller,
                    onSubmitted: (value) => setState(() {
                      q5 = value;
                    }),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your answer',
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                    '6. What type of contact have you made in the last 2 weeks?'),
                const SizedBox(height: 6),
                Column(
                    children: Q6.map((q) {
                  return CheckboxListTile(
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -4),
                      value: q["label"],
                      title: Text(q["value"]),
                      onChanged: (newValue) {
                        setState(() {
                          q["label"] = newValue;
                        });
                      });
                }).toList()),
                const SizedBox(height: 14),
                const Text('7. How many hours did you spend with the family?'),
                const SizedBox(height: 6),
                Column(
                  children: valuesQ7.map(
                    (value) {
                      selectedValueQ7 == value;

                      return RadioListTile<String>(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        value: value,
                        groupValue: selectedValueQ7,
                        title: Text(
                          value,
                        ),
                        onChanged: (value) =>
                            setState(() => selectedValueQ7 = value!),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: 14),
                const Text(
                    '8. Have you had to contact any of the following since our last check in?'),
                const SizedBox(height: 6),
                Column(
                  children: valuesQ8.map(
                    (value) {
                      selectedValueQ8 == value;

                      return RadioListTile<String>(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        value: value,
                        groupValue: selectedValueQ8,
                        title: Text(
                          value,
                        ),
                        onChanged: (value) =>
                            setState(() => selectedValueQ8 = value!),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: 14),
                const Text(
                    '9. Do you have a case plan in place for the family?'),
                const SizedBox(height: 6),
                Column(
                  children: valuesQ9.map(
                    (value) {
                      selectedValueQ9 == value;

                      return RadioListTile<String>(
                        value: value,
                        groupValue: selectedValueQ9,
                        title: Text(
                          value,
                        ),
                        onChanged: (value) =>
                            setState(() => selectedValueQ9 = value!),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: 14),
                const Text(
                    '10. Have you submitted case notes for the last two weeks detailing any of the following?'),
                const SizedBox(height: 6),
                Column(
                    children: Q10.map((q) {
                  return CheckboxListTile(
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -4),
                      value: q["label"],
                      title: Text(q["value"]),
                      onChanged: (newValue) {
                        setState(() {
                          q["label"] = newValue;
                        });
                      });
                }).toList()),
                const SizedBox(height: 14),
                const Text(
                    '11. Are you confident that the family are working towards the goals set out in you case plans?'),
                const SizedBox(height: 6),
                Column(
                  children: valuesQ11.map(
                    (value) {
                      selectedValueQ11 == value;

                      return RadioListTile<String>(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        value: value,
                        groupValue: selectedValueQ11,
                        title: Text(
                          value,
                        ),
                        onChanged: (value) =>
                            setState(() => selectedValueQ11 = value!),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: 14),
                const Text(
                    '12. If you answered no to Question 11, please explain in more detail your concerns.'),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: q12COntroller,
                    onSubmitted: (value) => setState(() {
                      q12 = value;
                    }),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your answer',
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                    '13. Have any issues asrisen since our last check in?'),
                const SizedBox(height: 6),
                Column(
                  children: valuesQ13.map(
                    (value) {
                      selectedValueQ8 == value;

                      return RadioListTile<String>(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        value: value,
                        groupValue: selectedValueQ13,
                        title: Text(
                          value,
                        ),
                        onChanged: (value) =>
                            setState(() => selectedValueQ13 = value!),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: 14),
                const Text(
                    '14. Please decsribe in more detail any concers or issues that you are currently dealing with.'),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: q14COntroller,
                    onSubmitted: (value) => setState(() {
                      q14 = value;
                    }),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your answer',
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                    '15. Do you have any additional support in the coming weeks to ensure the family are keeping on track with their objectives?'),
                const SizedBox(height: 6),
                Column(
                  children: valuesQ15.map(
                    (value) {
                      selectedValueQ15 == value;

                      return RadioListTile<String>(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        value: value,
                        groupValue: selectedValueQ15,
                        title: Text(
                          value,
                        ),
                        onChanged: (value) =>
                            setState(() => selectedValueQ15 = value!),
                      );
                    },
                  ).toList(),
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
        ),
      ),
    );
  }
}
