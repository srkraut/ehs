import 'package:ehs/constants/keys.dart';
import 'package:ehs/routing/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../home_page.dart';
import 'account_page.dart';

class Expenses extends StatefulWidget {
  const Expenses({Key? key}) : super(key: key);
  static Future<void> show(
    BuildContext context,
  ) async {
    await Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        AppRoutes.expensesPage, (Route<dynamic> route) => false);
  }

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  TimeOfDay currentTime = TimeOfDay.now();
  DateTime currentDate = DateTime.now();
  bool _isTimeSelected = false;
  bool _isDateSelected = false;

  final travel = TextEditingController();
  final distanceT = TextEditingController();
  final cost = TextEditingController();
  final phone = TextEditingController();
  final internet = TextEditingController();
  final other = TextEditingController();

  String? selectedDate,
      selectedTime,
      selectedTravel,
      distance,
      travelCost,
      phoneCharge,
      internetCharge,
      otherExpenses;

  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  void _onSubmit() {
    firestoreInstance
        .collection("users")
        .doc(firebaseUser!.uid)
        .collection("Expenses")
        .add({
      "selectedDate": DateFormat('EEEEEE, M/d/y').format(currentDate),
      "selectedTime": currentTime.format(context).toString(),
      "selectedTravel": selectedTravel,
      "distance": distance,
      "travelCost": travelCost,
      "phoneCharge": phoneCharge,
      "internetCharge": internetCharge,
      "otherExpenses": otherExpenses,
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Form Submitted"),
      duration: Duration(milliseconds: 500),
    ));

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
        (route) => false);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
      initialEntryMode: TimePickerEntryMode.input,
      helpText: "Choose Your Time",
      confirmText: 'Choose Now',
      cancelText: 'Later',
    );
    if (pickedTime != null && pickedTime != currentTime) {
      setState(() {
        currentTime = pickedTime;

        _isTimeSelected = true;
      });
    }
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    travel.dispose();
    distanceT.dispose();
    cost.dispose();
    phone.dispose();
    internet.dispose();
    other.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const Drawer(
          backgroundColor: Colors.grey,
          child: AccountPage(),
        ),
        appBar: AppBar(
          title: const Text('Expenses'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Please Select',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 14),
                    Container(
                      padding: const EdgeInsets.only(top: 9, left: 10),
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Text(_isDateSelected
                            ? DateFormat('EEEEEE, M/d/y').format(currentDate)
                            : 'Day'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.timer),
                    const SizedBox(width: 14),
                    Container(
                      padding: const EdgeInsets.only(top: 9, left: 10),
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: InkWell(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: Text(_isTimeSelected
                            ? currentTime.format(context).toString()
                            : 'Time'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.car_rental),
                    const SizedBox(width: 14),
                    Container(
                      padding: const EdgeInsets.only(top: 9, left: 10),
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: TextField(
                        controller: travel,
                        onSubmitted: (value) => setState(() {
                          selectedTravel = value;
                        }),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Method of Travel',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.add_road),
                    const SizedBox(width: 14),
                    Container(
                      padding: const EdgeInsets.only(top: 9, left: 10),
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: distanceT,
                        onSubmitted: (value) => setState(() {
                          distance = value;
                        }),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Kilometers travelled'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.money),
                    const SizedBox(width: 14),
                    Container(
                      padding: const EdgeInsets.only(top: 9, left: 10),
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: cost,
                        onSubmitted: (value) => setState(() {
                          travelCost = value;
                        }),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Cost of travel'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.phone),
                    const SizedBox(width: 14),
                    Container(
                      padding: const EdgeInsets.only(top: 9, left: 10),
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: phone,
                        onSubmitted: (value) => setState(() {
                          phoneCharge = value;
                        }),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Phone Charges'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.network_cell),
                    const SizedBox(width: 14),
                    Container(
                      padding: const EdgeInsets.only(top: 9, left: 10),
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: internet,
                        onSubmitted: (value) => setState(() {
                          internetCharge = value;
                        }),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Internet Charges'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: TextField(
                    controller: other,
                    onSubmitted: (value) => setState(() {
                      otherExpenses = value;
                    }),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Any other expenses please specify'),
                  ),
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
