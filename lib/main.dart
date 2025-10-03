import 'package:provider/provider.dart';
import 'package:chronocancer_ai/features/patient/pages/cancer_awareness_page.dart';
//import 'package:chronocancer_ai/features/patient/pages/doctor_list_page.dart';
import 'package:chronocancer_ai/features/patient/pages/family_page.dart';
import 'package:chronocancer_ai/features/patient/pages/health_monitoring_page.dart';
import 'package:chronocancer_ai/features/patient/pages/patient_details_1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chronocancer_ai/features/auth/pages/consent_page.dart';
import 'package:chronocancer_ai/features/auth/pages/onboarding2_page.dart';
import 'package:chronocancer_ai/features/auth/pages/onboarding3_page.dart';
import 'package:chronocancer_ai/features/auth/pages/role_selection_page.dart';
import 'package:chronocancer_ai/features/auth/pages/signup_page.dart';
import 'package:chronocancer_ai/features/auth/pages/splash_screen.dart';
import 'package:chronocancer_ai/features/doctor/pages/analytics_dashboard_page.dart';
import 'package:chronocancer_ai/features/doctor/pages/decision_support_page.dart';
import 'package:chronocancer_ai/features/doctor/pages/doctor_home.dart';
import 'package:chronocancer_ai/features/doctor/pages/patient_detail_page.dart';
import 'package:chronocancer_ai/features/doctor/pages/prescription_page.dart';
import 'package:chronocancer_ai/features/doctor/pages/risk_queue_page.dart';
import 'package:chronocancer_ai/features/doctor/pages/teleconsult_page.dart';
import 'package:chronocancer_ai/features/patient/pages/appointment_booking_page.dart';
import 'package:chronocancer_ai/features/patient/pages/bp_entry_page.dart';
import 'package:chronocancer_ai/features/auth/pages/login_page.dart';

import 'package:chronocancer_ai/features/auth/pages/onboarding1_page.dart';
import 'package:chronocancer_ai/features/patient/pages/patient_home.dart';
import 'package:chronocancer_ai/features/worker/pages/community_dashboard_page.dart';
import 'package:chronocancer_ai/features/worker/pages/patient_queue_page.dart';
import 'package:chronocancer_ai/features/worker/pages/report_upload_page.dart';
import 'package:chronocancer_ai/features/worker/pages/training_hub_page.dart';
import 'package:chronocancer_ai/features/worker/pages/worker_home.dart';
import 'package:chronocancer_ai/features/chatbot/pages/chatbot_page.dart';
import 'package:chronocancer_ai/features/patient/pages/report_analyzer_page.dart';
import 'package:chronocancer_ai/firebase_options.dart';
import 'package:flutter/material.dart';

import 'package:chronocancer_ai/features/patient/pages/patient_data.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
    runApp(
      ChangeNotifierProvider(
        create: (_) => PatientData(), // <-- your provider
        child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',    
      routes: { //splash onboarding1-2-3 select_profesion login signin consent userData 
        // '/':(context) =>  ChatScreen(),
        // '/':(context) => const ReportAnalyzerPage(),
        '/':(context) => const SplashPage(),
        
        '/consentPage':(context) => const PrivacyConsentScreen(),
        //'/loginPage':(context) => const LoginPage(role: role),
        '/onboarding1':(context) => const Onboarding1(),
        '/onboarding2':(context) => const Onboarding2(),
        '/onboarding3':(context) => const LocationNotifierScreen(),
        '/roleSelection':(context) => UserSelectionPage(),
        '/signupPage':(context) =>  SignupPage(role: '',),
        '/splashScreen':(context) => const SplashPage(),
        '/analyticsDashboard':(context) => const HealthAnalyticsScreen(),
        '/doctorsHome':(context) => const DoctorHomePage(),
        '/scheduling':(context) => const SchedulingPage(),
        '/BPentryPage':(context) => const BloodPressureApp(),
        '/patientHome':(context) => const HomePage(),
        '/communityDashboard' : (context) => const AshaWorkerDashboard(),
        '/patientQueue':(context) => const PatientQueue(),
        '/reportUpload':(context) => const AshaWorkerReportsScreen(),
        '/trainingHub':(context) => const TrainingHubScreen(),
        '/workerHome':(context) => const AshaDashBoard(),
        '/decisionSupport':(context) => const DecisionSupportPage(),
        '/patientDetails':(context) => PatientDetailPage(),
        '/prescription':(context) => const PrescriptionPage(),
        '/riskQueue':(context) => const RiskQueueScreen(),
        '/teleConsult':(context) => const TeleconsultPage(),
        '/cancerAwareness':(context) => const CancerAwarenessPage(),
        '/healthMonitoring':(context) => const HealthMonitoringPage(),
        '/patientProfile':(context) => const PatientDetailPage(),
        '/family':(context) => const CommunityInsightsApp(),
        //'/doctorsList':(context) => const DoctorDetailsPage(doctor: doctor)
      }
    );
  }
}