import 'package:ehs/constants/keys.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String yes = 'Yes';
const String no = 'No';
const String noPlease = 'No, please give more details in Q5';
const String hrs = '0-1 Hours';
const String hrs1 = '1-2 Hours';
const String hrs2 = '2+ Hours';
const String none = 'None';
const String local =
    'Local Community services(i.e:playgroups,library,craft group)';
const String additional =
    'Additional allied health services(e.g:CPS, SFSK, CAHMS)';
const String gp = 'Family\'s GP';
const String other = 'Other';
const String unsure = 'Unsure';

enum Survey4 { yes, no, noPlease }
enum Survey7 { hrs, hrs1, hrs2, none }
enum Survey8 { local, additional, gp, other, none }
enum Survey9 { yes, no }
enum Survey11 { yes, no }
enum Survey13 { yes, no }
enum Survey15 { yes, no, unsure }

class Survey extends StatefulWidget {
  Survey({Key? key}) : super(key: key);

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

  Survey4 _value = Survey4.yes;
  Survey7 _value2 = Survey7.hrs;
  Survey8 _value3 = Survey8.local;
  Survey9 _value4 = Survey9.yes;
  Survey11 _value5 = Survey11.yes;
  Survey13 _value6 = Survey13.yes;
  Survey15 _value7 = Survey15.yes;

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(yes),
                    leading: Radio(
                      value: Survey4.yes,
                      groupValue: _value,
                      onChanged: (Survey4? value) => setState(() {
                        _value = value!;
                      }),
                    )),
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(no),
                    leading: Radio(
                      value: Survey4.no,
                      groupValue: _value,
                      onChanged: (Survey4? value) => setState(() {
                        _value = value!;
                      }),
                    )),
                ListTile(
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  title: const Text(noPlease),
                  leading: Radio(
                    value: Survey4.noPlease,
                    groupValue: _value,
                    onChanged: (Survey4? value) => setState(() {
                      _value = value!;
                    }),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                    '5. If you answered no to Question 4, please explain in more detail shy you have not contacted the family'),
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
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(hrs),
                    leading: Radio(
                      value: Survey7.hrs,
                      groupValue: _value2,
                      onChanged: (Survey7? value) => setState(() {
                        _value2 = value!;
                      }),
                    )),
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(hrs1),
                    leading: Radio(
                      value: Survey7.hrs1,
                      groupValue: _value2,
                      onChanged: (Survey7? value) => setState(() {
                        _value2 = value!;
                      }),
                    )),
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(hrs2),
                    leading: Radio(
                      value: Survey7.hrs2,
                      groupValue: _value2,
                      onChanged: (Survey7? value) => setState(() {
                        _value2 = value!;
                      }),
                    )),
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(none),
                    leading: Radio(
                      value: Survey7.none,
                      groupValue: _value2,
                      onChanged: (Survey7? value) => setState(() {
                        _value2 = value!;
                      }),
                    )),
                const SizedBox(height: 14),
                const Text(
                    '8. Have you had to contact any of the following since our last check in?'),
                const SizedBox(height: 6),
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(local),
                    leading: Radio(
                      value: Survey8.local,
                      groupValue: _value3,
                      onChanged: (Survey8? value) => setState(() {
                        _value3 = value!;
                      }),
                    )),
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(additional),
                    leading: Radio(
                      value: Survey8.additional,
                      groupValue: _value3,
                      onChanged: (Survey8? value) => setState(() {
                        _value3 = value!;
                      }),
                    )),
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(gp),
                    leading: Radio(
                      value: Survey8.gp,
                      groupValue: _value3,
                      onChanged: (Survey8? value) => setState(() {
                        _value3 = value!;
                      }),
                    )),
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(other),
                    leading: Radio(
                      value: Survey8.other,
                      groupValue: _value3,
                      onChanged: (Survey8? value) => setState(() {
                        _value3 = value!;
                      }),
                    )),
                const SizedBox(height: 14),
                const Text(
                    '9. Do you have a case plan in place for the family?'),
                const SizedBox(height: 6),
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(yes),
                    leading: Radio(
                      value: Survey9.yes,
                      groupValue: _value4,
                      onChanged: (Survey9? value) => setState(() {
                        _value4 = value!;
                      }),
                    )),
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(no),
                    leading: Radio(
                      value: Survey9.no,
                      groupValue: _value4,
                      onChanged: (Survey9? value) => setState(() {
                        _value4 = value!;
                      }),
                    )),
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
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(yes),
                    leading: Radio(
                      value: Survey11.yes,
                      groupValue: _value5,
                      onChanged: (Survey11? value) => setState(() {
                        _value5 = value!;
                      }),
                    )),
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(no),
                    leading: Radio(
                      value: Survey11.no,
                      groupValue: _value5,
                      onChanged: (Survey11? value) => setState(() {
                        _value5 = value!;
                      }),
                    )),
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
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(yes),
                    leading: Radio(
                      value: Survey13.yes,
                      groupValue: _value6,
                      onChanged: (Survey13? value) => setState(() {
                        _value6 = value!;
                      }),
                    )),
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(no),
                    leading: Radio(
                      value: Survey13.no,
                      groupValue: _value6,
                      onChanged: (Survey13? value) => setState(() {
                        _value6 = value!;
                      }),
                    )),
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
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(yes),
                    leading: Radio(
                      value: Survey15.yes,
                      groupValue: _value7,
                      onChanged: (Survey15? value) => setState(() {
                        _value7 = value!;
                      }),
                    )),
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(no),
                    leading: Radio(
                      value: Survey15.no,
                      groupValue: _value7,
                      onChanged: (Survey15? value) => setState(() {
                        _value7 = value!;
                      }),
                    )),
                ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: const Text(unsure),
                    leading: Radio(
                      value: Survey15.unsure,
                      groupValue: _value7,
                      onChanged: (Survey15? value) => setState(() {
                        _value7 = value!;
                      }),
                    )),
                const SizedBox(height: 14),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Keys.pColor),
                  ),
                  onPressed: null,
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
