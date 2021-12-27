import 'package:ehs/app/home/drawer/timesheets_page.dart';
import 'package:ehs/constants/keys.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ehs/app/auth_widget.dart';
import 'package:ehs/app/home/home_page.dart';
import 'package:ehs/app/onboarding/onboarding_page.dart';
import 'package:ehs/app/onboarding/onboarding_view_model.dart';
import 'package:ehs/app/top_level_providers.dart';
import 'package:ehs/app/sign_in/sign_in_page.dart';
import 'package:ehs/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ehs/services/shared_preferences_service.dart';

import 'dependencies/email_password_sign_in_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [
      sharedPreferencesServiceProvider.overrideWithValue(
        SharedPreferencesService(sharedPreferences),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    return MaterialApp(
      theme: ThemeData(primarySwatch: Keys.pColor),
      debugShowCheckedModeBanner: false,
      home: AuthWidget(
        nonSignedInBuilder: (_) => Consumer(
          builder: (context, ref, _) {
            final didCompleteOnboarding =
                ref.watch(onboardingViewModelProvider);
            return didCompleteOnboarding
                ? EmailPasswordSignInPage.withFirebaseAuth(firebaseAuth)
                : const OnboardingPage();
          },
        ),
        signedInBuilder: (_) =>  HomePage(),
      ),
      onGenerateRoute: (settings) =>
          AppRouter.onGenerateRoute(settings, firebaseAuth),
    );
  }
}
