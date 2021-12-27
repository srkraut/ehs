
import 'package:ehs/app/home/drawer/expenses_page.dart';
import 'package:ehs/app/home/drawer/my_families.dart';
import 'package:ehs/app/home/drawer/survey_page.dart';
import 'package:ehs/app/home/home_page.dart';
import 'package:ehs/dependencies/email_password_sign_in_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ehs/app/home/job_entries/entry_page.dart';
import 'package:ehs/app/home/jobs/edit_job_page.dart';
import 'package:ehs/app/home/models/entry.dart';
import 'package:ehs/app/home/models/job.dart';
import 'package:ehs/app/home/drawer/timesheets_page.dart';

class AppRoutes {
  static const emailPasswordSignInPage = '/email-password-sign-in-page';
  static const editJobPage = '/edit-job-page';
  static const entryPage = '/entry-page';
  static const familiesPage = '/families-page';
  static const expensesPage = '/expenses-page';
  static const timesheets = '/timesheet-page';
  static const surveyPage = '/survey-page';
  static const homePage = '/home-page';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(
      RouteSettings settings, FirebaseAuth firebaseAuth) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.emailPasswordSignInPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EmailPasswordSignInPage.withFirebaseAuth(firebaseAuth,
              onSignedIn: args as void Function()),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.editJobPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditJobPage(job: args as Job?),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.entryPage:
        final mapArgs = args as Map<String, dynamic>;
        final job = mapArgs['job'] as Job;
        final entry = mapArgs['entry'] as Entry?;
        return MaterialPageRoute<dynamic>(
          builder: (_) => EntryPage(job: job, entry: entry),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.surveyPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => Survey(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.homePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => HomePage(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.expensesPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const Expenses(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.familiesPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const MyFamilies(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.timesheets:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const TimeSheet(),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
        // TODO: Throw
        return null;
    }
  }
}
