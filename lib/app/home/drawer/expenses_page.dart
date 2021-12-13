import 'package:ehs/constants/keys.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  TimeOfDay currentTime = TimeOfDay.now();
  DateTime currentDate = DateTime.now();
  bool _isTimeSelected = false;

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

  @override
  Widget build(BuildContext context) {
    String? dayValue;
    List<String> days = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];
    String travelValue;
    List<String> travels = [
      "Airplane",
      "Bus",
      "Car",
      "Train",
      "Bicycle",
      "Walk",
      "Other"
    ];
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Please Select'),
                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 14),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: DropdownButton<String>(
                        underline: Container(),
                        onChanged: (newValue) {
                          setState(() {
                            dayValue = newValue!;
                          });
                        },
                        value: dayValue,
                        //isExpanded: true,
                        hint: Text('  Day'),
                        icon: const Icon(Icons.arrow_drop_down),
                        items: days.map((items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                      ),
                    ),
                    // buildDropDownButton(Icons.arrow_drop_down, days),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.timer),
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
                              _selectTime(context);
                            },
                            child: Text(_isTimeSelected
                                ? currentTime.format(context).toString()
                                : '  Select your time'),
                          ),
                          const SizedBox(width: 14),
                          const Icon(
                            Icons.timer,
                          ),
                        ],
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
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: DropdownButton<String>(
                        onChanged: (newValue) {
                          setState(() {
                            travelValue = newValue!;
                          });
                        },
                        underline: Container(),
                        value: dayValue,
                        //isExpanded: true,
                        hint: Text('  Method of Travel'),
                        icon: const Icon(Icons.arrow_drop_down),
                        items: travels.map((items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 14),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '   Kilometers travelled'),
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
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '   Cost of travel'),
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
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '   Phone Charges'),
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
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '   Internet Charged'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '   Any other expenses please specify'),
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Keys.pColor),
                  ),
                  onPressed: null,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
