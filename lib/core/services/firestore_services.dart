import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  // Generic update methods (already in your old code)
  Future<void> updateField(String fieldName, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(uid).set(
        {fieldName: data},
        SetOptions(merge: true),
      );
    } catch (e) {
      print('Error updating $fieldName: $e');
      rethrow;
    }
  }

  Future<void> updateSimpleField(String fieldName, dynamic value) async {
    try {
      await _db.collection('users').doc(uid).set(
        {fieldName: value},
        SetOptions(merge: true),
      );
    } catch (e) {
      print('Error updating $fieldName: $e');
      rethrow;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc() {
    return _db.collection('users').doc(uid).get();
  }

  // -----------------------------
  // Multi-page Medical Data Methods
  // -----------------------------

  Future<void> savePageData(String pageName, Map<String, dynamic> data) async {
    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('medical_data')
          .doc(pageName)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error saving $pageName: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getPageData(String pageName) async {
    try {
      DocumentSnapshot doc = await _db
          .collection('users')
          .doc(uid)
          .collection('medical_data')
          .doc(pageName)
          .get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error fetching $pageName: $e');
      return null;
    }
  }

  // Page-specific convenience methods
  Future<void> savePage1BasicInfo(Map<String, dynamic> data) =>
      savePageData("page1_basic_info", data);
  Future<void> savePage2ChronicDiseases(Map<String, dynamic> data) =>
      savePageData("page2_chronic_diseases", data);
  Future<void> savePage3Lifestyle(Map<String, dynamic> data) =>
      savePageData("page3_lifestyle", data);
  Future<void> savePage4FamilyHistory(Map<String, dynamic> data) =>
      savePageData("page4_family_history", data);
  Future<void> savePage5CancerScreening(Map<String, dynamic> data) =>
      savePageData("page5_cancer_screening", data);
  Future<void> savePage6ReproductiveHistory(Map<String, dynamic> data) =>
      savePageData("page6_reproductive_history", data);
  Future<void> savePage7Symptoms(Map<String, dynamic> data) =>
      savePageData("page7_symptoms", data);
}