// patient_data.dart
import 'package:flutter/material.dart';

class PatientData extends ChangeNotifier {
  // Page 1: Basic Profile
  String? fullName;
  int age = 18;
  int gender = 0; // 0: Male, 1: Female, 2: Other
  int height = 170; // cm
  int weight = 70; // kg
  String? phoneNumber;
  String? email;
  String? address;
  String? emergencyContact;
  double? bmi; // auto-calculated
  String? ageRiskFactor; // auto-calculated

  // Page 2: Lifestyle Factors
  int smokingStatus = 0; // 0: Never, 1: Former, 2: Current
  int? smokingYears;
  int? cigarettesPerDay;
  int alcoholConsumption = 0; // 0: Never, 1: Occasional, 2: Moderate, 3: Heavy
  int? drinksPerWeek;
  int physicalActivityHoursPerWeek = 0;
  String activityType = 'Sedentary'; // Sedentary, Light, Moderate, Vigorous
  String dietType = 'Non-Veg'; // Vegetarian, Non-Veg, Vegan, Mixed
  String redMeatFrequency = 'Rarely'; // Never, Rarely, Often, Daily
  String processedFoodConsumption = 'Low'; // Low, Medium, High
  int fruitVegetableIntake = 3; // 1-5 rating
  int sleepHoursPerNight = 7;
  int sleepQuality = 3; // 1-4 rating
  int stressLevel = 2; // 1-4 rating
  bool anxietyDepression = false;

  // Page 3: Family History
  bool familyCancerHistory = false;
  List<Map<String, dynamic>> familyMembersWithCancer = [];
  bool familyDiabetes = false;
  bool familyHypertension = false;
  bool familyHeartDisease = false;
  bool familyKidneyDisease = false;
  bool familyLiverDisease = false;
  bool familyAutoimmuneDisease = false;
  bool consanguineousMarriageInFamily = false;
  bool multipleFamilyMembersSameCancer = false;

  // Page 4: Chronic Diseases (Current)
  bool hasDiabetes = false;
  String? diabetesType; // Type 1, Type 2, Gestational, Prediabetes
  int? diabetesDurationYears;
  double? hba1cLatest;
  int? fastingGlucose;
  String? diabetesControlled; // Well-controlled, Moderately, Poorly
  List<String> diabetesMedications = [];

  bool metabolicSyndromeDiagnosed = false;
  int? waistCircumference;

  bool hasCopd = false;
  String? copdSeverity;
  String? chronicCoughDuration;

  bool hasAsthma = false;
  String? asthmaSeverity;

  bool hasHepatitisB = false;
  bool hasHepatitisC = false;
  bool alcoholicLiverDisease = false;
  bool fattyLiverNafld = false;
  bool cirrhosis = false;

  bool hasCrohnsDisease = false;
  bool hasUlcerativeColitis = false;
  int? ibdDurationYears;

  bool hasGerd = false;
  int? gerdDurationYears;
  bool hasBarrettsEsophagus = false;

  bool hasHPyloriInfection = false;
  bool chronicGastritis = false;

  bool hasCkd = false;
  int? ckdStage; // 1-5
  bool onDialysis = false;

  bool hasHypertension = false;
  int? bpSystolicUsual;
  int? bpDiastolicUsual;
  String? hypertensionControlled; // Well, Moderately, Poorly
  List<String> bpMedications = [];

  bool hasBph = false; // Males only

  String? hpvPositive; // Yes/No/Unknown
  bool hpvVaccinated = false;
  bool historyOfStis = false;

  bool hasHiv = false;
  bool hivControlled = false;
  int? cd4Count;
  bool onImmunosuppressants = false;
  String? immunosuppressantReason;

  bool hasHashimotos = false;
  bool thyroidNodules = false;

  // Page 5: Lab Results (Latest)
  String? labReportPath; // Example for file path or URL
  double? hba1c;
  int? fastingGlucoseLab;
  int? randomGlucose;
  DateTime? lastSugarTestDate;

  int? cholesterolTotal;
  int? cholesterolLdl;
  int? cholesterolHdl;
  int? triglycerides;
  DateTime? lastLipidTestDate;

  int? bpSystolicLatest;
  int? bpDiastolicLatest;
  DateTime? bpMeasurementDate;

  double? crpCReactiveProtein;
  int? esrErythrocyteSedimentationRate;

  int? wbcWhiteBloodCells;
  double? hemoglobin;
  int? platelets;

  int? altSgpt;
  int? astSgot;
  double? bilirubinTotal;
  double? albumin;

  double? creatinine;
  int? bunBloodUreaNitrogen;
  int? egfr;

  double? tshThyroidStimulatingHormone;
  double? t3;
  double? t4;

  double? psaProstateSpecificAntigen;
  double? ceaCarcinoembryonicAntigen;
  double? afpAlphaFetoprotein;
  double? ca125;

  // Page 6: Cancer-Specific Symptoms Screening
  bool unexplainedWeightLoss6Months = false;
  int? weightLostKg;

  bool persistentFatigue = false;
  int? fatigueDurationWeeks;

  bool anyLumpsSwellings = false;
  List<String> lumpLocations = [];

  bool unusualBleeding = false;
  List<String> bleedingTypes = [];

  bool persistentPain = false;
  List<String> painLocations = [];
  int? painDurationWeeks;

  // Respiratory Symptoms
  bool persistentCough3Weeks = false;
  bool coughingBlood = false;
  bool progressiveBreathlessness = false;
  bool recurrentChestInfections = false;

  // Digestive Symptoms
  bool rectalBleeding = false;
  bool bloodInStool = false;
  String? stoolColorChange; // Black/Tarry, Red, Normal
  bool bowelHabitChange = false;
  bool constipationDiarrheaAlternating = false;
  bool difficultySwallowing = false;
  bool swallowingGetsWorse = false;
  bool earlySatietyFeelFullQuickly = false;
  bool vomitingBlood = false;
  bool persistentIndigestion = false;
  bool chronicRefluxNotRespondingToMeds = false;

  // Breast Symptoms
  bool breastLump = false;
  bool nippleDischarge = false;
  bool nippleDischargeBloody = false;
  bool nippleInversion = false;
  bool skinDimplingBreast = false;
  bool breastSkinChanges = false;

  // Urinary Symptoms
  bool bloodInUrinePainless = false;
  bool weakUrineStream = false;
  bool difficultyStartingStoppingUrination = false;
  bool nocturiaFrequent = false;
  bool incompleteBladderEmptying = false;

  // Gynecological
  bool abnormalVaginalBleeding = false;
  bool postIntercourseBleeding = false;
  bool betweenPeriodsBleeding = false;
  bool postMenopausalBleeding = false;
  bool foulSmellingDischarge = false;
  bool pelvicPainPersistent = false;

  // Liver Symptoms
  bool jaundiceYellowSkinEyes = false;
  bool rightUpperQuadrantPain = false;
  bool abdominalSwellingAscites = false;
  bool easyBruisingBleeding = false;

  // Thyroid/Neck Symptoms
  bool neckLumpNodule = false;
  bool hoarsenessVoiceChange = false;
  bool difficultySwallowingNeck = false;
  bool rapidNoduleGrowth = false;

  // Skin Changes
  bool newMole = false;
  bool changingMole = false;
  bool nonHealingSore = false;
  bool darkSkinPatch = false;

  // Neurological
  bool persistentHeadaches = false;
  bool visionChanges = false;
  bool seizures = false;
  bool dizzinessBalanceIssues = false;

  // Notifying listeners about changes
  void update() {
    notifyListeners();
  }

  // Method to calculate BMI (can be called from Page 1 or when height/weight changes)
  void calculateBmi() {
    if (height > 0 && weight > 0) {
      bmi = weight / ((height / 100) * (height / 100));
      ageRiskFactor = (age > 50) ? "High" : "Moderate";
    } else {
      bmi = null;
      ageRiskFactor = null;
    }
    notifyListeners();
  }
}