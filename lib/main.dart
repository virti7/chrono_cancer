import 'package:chronocancer_ai/features/auth/pages/consent_page.dart';
import 'package:chronocancer_ai/features/auth/pages/onboarding2_page.dart';
import 'package:chronocancer_ai/features/auth/pages/onboarding3_page.dart';
import 'package:chronocancer_ai/features/auth/pages/role_selection_page.dart';
//import 'package:chronocancer_ai/features/auth/pages/signup_page.dart';
import 'package:chronocancer_ai/features/auth/pages/splash_screen.dart';
import 'package:chronocancer_ai/features/doctor/pages/analytics_dashboard_page.dart';
import 'package:chronocancer_ai/features/patient/pages/appointment_booking_page.dart';
import 'package:chronocancer_ai/features/patient/pages/bp_entry_page.dart';
//import 'package:chronocancer_ai/features/auth/pages/login_page.dart';
import 'package:chronocancer_ai/features/auth/pages/onboarding1_page.dart';
import 'package:chronocancer_ai/features/patient/pages/patient_home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',    
      routes: { //splash onboarding1-2-3 select_profesion login signin consent userData 
        '/':(context) => const SplashPage(),
        '/consentPage':(context) => const PrivacyConsentScreen(),
        //'/loginPage':(context) => const LoginPage(role: role),
        '/onboarding1':(context) => const Onboarding1(),
        '/onboarding2':(context) => const Onboarding2(),
        '/onboarding3':(context) => const LocationNotifierScreen(),
        '/roleSelection':(context) => UserSelectionPage(),
        //'/signupPage':(context) => const SignupPage(),
        '/splashScreen':(context) => const SplashPage(),
        '/analyticsDashboard':(context) => const HealthAnalyticsScreen(),
        '/scheduling':(context) => const SchedulingPage(),
        '/BPentryPage':(context) => const BloodPressureApp(),
        '/patientHome':(context) => const HomePage(),
      }
    );
  }
}
