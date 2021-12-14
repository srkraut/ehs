import 'package:flutter/material.dart';

class Keys {
  static const String emailPassword = 'email-password';
  static const String anonymous = 'anonymous';
  static const String tabBar = 'tabBar';
  static const String jobsTab = 'jobsTab';
  static const String entriesTab = 'entriesTab';
  static const String accountTab = 'accountTab';
  static const String logout = 'logout';
  static const String alertDefault = 'alertDefault';
  static const String alertCancel = 'alertCancel';

  static const MaterialColor pColor = MaterialColor(
    0xFF72bbb1, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff67a89f), //10%
      100: Color(0xff5b968e), //20%
      200: Color(0xff50837c), //30%
      300: Color(0xff44706a), //40%
      400: Color(0xff395e59), //50%
      500: Color(0xff2e4b47), //60%
      600: Color(0xff223835), //70%
      700: Color(0xff172523), //80%
      800: Color(0xff0b1312), //90%
      900: Color(0xff000000), //100%
    },
  );
  // Survey Page
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String noPlease = 'No, please give more details in Q5';
}
