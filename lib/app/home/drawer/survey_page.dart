import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Survey Page
const String yes = 'Yes';
const String no = 'No';
const String noPlease = 'No, please give more details in Q5';
enum Survey4 { yes, no, noPlease }

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

  Survey4 _value = Survey4.yes;

  String? date, volunteer_no, name, q5;

  List<Map> Q6 = [
    {'value': 'Telephone Call', 'label': false},
    {'value': 'Email', 'label': false},
    {'value': 'Text', 'label': false},
    {'value': 'In person meetup', 'label': false},
    {'value': 'None', 'label': false},
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
                  //height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: TextField(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
