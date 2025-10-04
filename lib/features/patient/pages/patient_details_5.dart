// patient_details_5.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'patient_data.dart';
import 'patient_details_6.dart';
import 'package:chronocancer_ai/features/patient/pages/firestore_service.dart';

class PatientDetails5 extends StatefulWidget {
  const PatientDetails5({super.key});

  @override
  State<PatientDetails5> createState() => _PatientDetails5State();
}

class _PatientDetails5State extends State<PatientDetails5>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final firestoreService = FirestoreService();
  XFile? labReportFile;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _pickLabReport() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => labReportFile = file);
      context.read<PatientData>().labReportPath = file.path;
    }
  }

  void _selectDate(BuildContext context, DateTime? initialDate,
      ValueChanged<DateTime> onDateSelected) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade700,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) onDateSelected(date);
  }

  Color _highlightIfAbnormal(double? value, double min, double max) {
    if (value == null) return Colors.grey.shade800;
    return (value < min || value > max) ? Colors.red.shade700 : Colors.green.shade700;
  }

  Future<void> _saveAndNext(PatientData p) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      p.update();

      final data = {
        "hba1c": p.hba1c,
        "fasting_glucose_lab": p.fastingGlucoseLab,
        "random_glucose": p.randomGlucose,
        "last_sugar_test_date": p.lastSugarTestDate?.toIso8601String(),
        "cholesterol_total": p.cholesterolTotal,
        "cholesterol_ldl": p.cholesterolLdl,
        "cholesterol_hdl": p.cholesterolHdl,
        "triglycerides": p.triglycerides,
        "last_lipid_test_date": p.lastLipidTestDate?.toIso8601String(),
        "bp_systolic_latest": p.bpSystolicLatest,
        "bp_diastolic_latest": p.bpDiastolicLatest,
        "bp_measurement_date": p.bpMeasurementDate?.toIso8601String(),
        "crp": p.crpCReactiveProtein,
        "esr": p.esrErythrocyteSedimentationRate,
        "wbc": p.wbcWhiteBloodCells,
        "hemoglobin": p.hemoglobin,
        "platelets": p.platelets,
        "alt": p.altSgpt,
        "ast": p.astSgot,
        "bilirubin_total": p.bilirubinTotal,
        "albumin": p.albumin,
        "creatinine": p.creatinine,
        "bun": p.bunBloodUreaNitrogen,
        "egfr": p.egfr,
        "lab_report_path": p.labReportPath,
      };

      try {
        await firestoreService.updateField("page5_lab_results", data);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PatientDetails6()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save data: $e',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _skipAndNext(PatientData p) async {
    final data = {
      "hba1c": null,
      "fasting_glucose_lab": null,
      "random_glucose": null,
      "last_sugar_test_date": null,
      "cholesterol_total": null,
      "cholesterol_ldl": null,
      "cholesterol_hdl": null,
      "triglycerides": null,
      "last_lipid_test_date": null,
      "bp_systolic_latest": null,
      "bp_diastolic_latest": null,
      "bp_measurement_date": null,
      "crp": null,
      "esr": null,
      "wbc": null,
      "hemoglobin": null,
      "platelets": null,
      "alt": null,
      "ast": null,
      "bilirubin_total": null,
      "albumin": null,
      "creatinine": null,
      "bun": null,
      "egfr": null,
      "lab_report_path": null,
    };
    try {
      await firestoreService.updateField("page5_lab_results", data);
    } catch (_) {}
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PatientDetails6()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientData>(
      builder: (context, p, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF0F5F9),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 120,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade600,
                    Colors.indigo.shade400,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                color: Colors.white, size: 24),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.center,
                              child: Text(
                                'Lab Results (Latest)',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withOpacity(0.7),
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      unselectedLabelStyle: const TextStyle(fontSize: 14),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 4,
                      tabs: const [
                        Tab(text: 'Blood Sugar'),
                        Tab(text: 'Cholesterol'),
                        Tab(text: 'BP'),
                        Tab(text: 'Inflammation'),
                        Tab(text: 'CBC'),
                        Tab(text: 'Liver'),
                        Tab(text: 'Kidney'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Form(
            key: _formKey,
            child: TabBarView(
              controller: _tabController,
              children: [
                _bloodSugarTab(p),
                _cholesterolTab(p),
                _bpTab(p),
                _inflammationTab(p),
                _cbcTab(p),
                _liverTab(p),
                _kidneyTab(p),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _pickLabReport,
            label: Text(
              labReportFile != null ? 'Report Selected' : 'Upload Lab Report',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            icon: Icon(
              labReportFile != null ? Icons.check_circle_outline : Icons.upload_file,
              color: Colors.white,
            ),
            backgroundColor: labReportFile != null ? Colors.green.shade600 : Colors.blue.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Flexible(child: _buildBackButton()),
                const SizedBox(width: 8),
                Flexible(child: _buildNextButton(p)),
                const SizedBox(width: 8),
                Flexible(
                  child: TextButton(
                    onPressed: () => _skipAndNext(p),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const Text('Skip'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ----------------- TAB WIDGETS -----------------
  Widget _bloodSugarTab(PatientData p) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSectionCard(
              title: 'Blood Sugar Levels',
              icon: Icons.bloodtype_outlined,
              children: [
                _numberField(
                  label: 'HbA1c (%)',
                  value: p.hba1c ?? 5.0,
                  min: 4,
                  max: 14,
                  normalRange: '4.0 - 5.6',
                  onChanged: (v) => p.hba1c = v,
                ),
                _numberField(
                  label: 'Fasting Glucose (mg/dL)',
                  value: (p.fastingGlucoseLab ?? 90).toDouble(),
                  min: 70,
                  max: 126,
                  normalRange: '70 - 100',
                  onChanged: (v) => p.fastingGlucoseLab = v.toInt(),
                ),
                _numberField(
                  label: 'Random Glucose (mg/dL)',
                  value: (p.randomGlucose ?? 100).toDouble(),
                  min: 70,
                  max: 140,
                  normalRange: '70 - 140',
                  onChanged: (v) => p.randomGlucose = v.toInt(),
                ),
                _dateField(
                  label: 'Last Test Date',
                  date: p.lastSugarTestDate,
                  onDateSelected: (d) => p.lastSugarTestDate = d,
                ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _cholesterolTab(PatientData p) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSectionCard(
              title: 'Cholesterol Profile',
              icon: Icons.local_hospital_outlined,
              children: [
                _numberField(
                  label: 'Total Cholesterol (mg/dL)',
                  value: (p.cholesterolTotal ?? 180).toDouble(),
                  min: 100,
                  max: 240,
                  normalRange: '< 200',
                  onChanged: (v) => p.cholesterolTotal = v.toInt(),
                ),
                _numberField(
                  label: 'LDL (mg/dL)',
                  value: (p.cholesterolLdl ?? 100).toDouble(),
                  min: 0,
                  max: 160,
                  normalRange: '< 100',
                  onChanged: (v) => p.cholesterolLdl = v.toInt(),
                ),
                _numberField(
                  label: 'HDL (mg/dL)',
                  value: (p.cholesterolHdl ?? 50).toDouble(),
                  min: 20,
                  max: 100,
                  normalRange: '> 40',
                  onChanged: (v) => p.cholesterolHdl = v.toInt(),
                ),
                _numberField(
                  label: 'Triglycerides (mg/dL)',
                  value: (p.triglycerides ?? 120).toDouble(),
                  min: 50,
                  max: 200,
                  normalRange: '< 150',
                  onChanged: (v) => p.triglycerides = v.toInt(),
                ),
                _dateField(
                  label: 'Last Test Date',
                  date: p.lastLipidTestDate,
                  onDateSelected: (d) => p.lastLipidTestDate = d,
                ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _bpTab(PatientData p) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSectionCard(
              title: 'Blood Pressure',
              icon: Icons.monitor_heart_outlined,
              children: [
                _numberField(
                  label: 'Systolic BP (mmHg)',
                  value: (p.bpSystolicLatest ?? 120).toDouble(),
                  min: 90,
                  max: 200,
                  normalRange: '90 - 120',
                  onChanged: (v) => p.bpSystolicLatest = v.toInt(),
                ),
                _numberField(
                  label: 'Diastolic BP (mmHg)',
                  value: (p.bpDiastolicLatest ?? 80).toDouble(),
                  min: 60,
                  max: 120,
                  normalRange: '60 - 80',
                  onChanged: (v) => p.bpDiastolicLatest = v.toInt(),
                ),
                _dateField(
                  label: 'Measurement Date',
                  date: p.bpMeasurementDate,
                  onDateSelected: (d) => p.bpMeasurementDate = d,
                ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _inflammationTab(PatientData p) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSectionCard(
              title: 'Inflammation Markers',
              icon: Icons.sick_outlined,
              children: [
                _numberField(
                  label: 'CRP (mg/L)',
                  value: p.crpCReactiveProtein ?? 1.0,
                  min: 0,
                  max: 20,
                  normalRange: '< 3.0',
                  onChanged: (v) => p.crpCReactiveProtein = v,
                ),
                _numberField(
                  label: 'ESR (mm/hr)',
                  value: (p.esrErythrocyteSedimentationRate ?? 10).toDouble(),
                  min: 0,
                  max: 50,
                  normalRange: '< 20',
                  onChanged: (v) => p.esrErythrocyteSedimentationRate = v.toInt(),
                ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _cbcTab(PatientData p) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSectionCard(
              title: 'Complete Blood Count (CBC)',
              icon: Icons.colorize_outlined,
              children: [
                _numberField(
                  label: 'WBC (cells/μL)',
                  value: (p.wbcWhiteBloodCells ?? 6000).toDouble(),
                  min: 4000,
                  max: 11000,
                  normalRange: '4000 - 11000',
                  onChanged: (v) => p.wbcWhiteBloodCells = v.toInt(),
                ),
                _numberField(
                  label: 'Hemoglobin (g/dL)',
                  value: p.hemoglobin ?? 14,
                  min: 12,
                  max: 18,
                  normalRange: '12 - 16',
                  onChanged: (v) => p.hemoglobin = v,
                ),
                _numberField(
                  label: 'Platelets',
                  value: (p.platelets ?? 200000).toDouble(),
                  min: 150000,
                  max: 450000,
                  normalRange: '150000 - 450000',
                  onChanged: (v) => p.platelets = v.toInt(),
                ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _liverTab(PatientData p) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSectionCard(
              title: 'Liver Function Tests',
              icon: Icons.local_dining_outlined,
              children: [
                _numberField(
                  label: 'ALT (U/L)',
                  value: (p.altSgpt ?? 25).toDouble(),
                  min: 0,
                  max: 50,
                  normalRange: '7 - 56',
                  onChanged: (v) => p.altSgpt = v.toInt(),
                ),
                _numberField(
                  label: 'AST (U/L)',
                  value: (p.astSgot ?? 25).toDouble(),
                  min: 0,
                  max: 50,
                  normalRange: '10 - 40',
                  onChanged: (v) => p.astSgot = v.toInt(),
                ),
                _numberField(
                  label: 'Bilirubin Total (mg/dL)',
                  value: p.bilirubinTotal ?? 1.0,
                  min: 0,
                  max: 2,
                  normalRange: '0.1 - 1.2',
                  onChanged: (v) => p.bilirubinTotal = v,
                ),
                _numberField(
                  label: 'Albumin (g/dL)',
                  value: p.albumin ?? 4.0,
                  min: 3,
                  max: 5,
                  normalRange: '3.4 - 5.4',
                  onChanged: (v) => p.albumin = v,
                ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _kidneyTab(PatientData p) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSectionCard(
              title: 'Kidney Function Tests',
              icon: Icons.medical_services_outlined,
              children: [
                _numberField(
                  label: 'Creatinine (mg/dL)',
                  value: p.creatinine ?? 1.0,
                  min: 0.5,
                  max: 2.0,
                  normalRange: '0.6 - 1.2',
                  onChanged: (v) => p.creatinine = v,
                ),
                _numberField(
                  label: 'BUN (mg/dL)',
                  value: (p.bunBloodUreaNitrogen ?? 15).toDouble(),
                  min: 7,
                  max: 20,
                  normalRange: '7 - 20',
                  onChanged: (v) => p.bunBloodUreaNitrogen = v.toInt(),
                ),
                _numberField(
                  label: 'eGFR (mL/min)',
                  value: (p.egfr ?? 90).toDouble(),
                  min: 60,
                  max: 120,
                  normalRange: '> 60',
                  onChanged: (v) => p.egfr = v.toInt(),
                ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // ----------------- REUSABLE WIDGETS -----------------
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue.shade700, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(height: 30, thickness: 1, color: Color(0xFFE0E6EE)),
          ...children,
        ],
      ),
    );
  }

  Widget _numberField({
    required String label,
    required double value,
    required double min,
    required double max,
    required String normalRange,
    required ValueChanged<double> onChanged,
  }) {
    final color = _highlightIfAbnormal(value, min, max);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: value.toStringAsFixed(
            (value == value.toInt().toDouble()) ? 0 : 1),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade500),
          suffixText: 'Normal: $normalRange',
          suffixStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.numbers, color: Colors.blue.shade400, size: 22),
          prefixIconConstraints: const BoxConstraints(minWidth: 40),
          filled: true,
          fillColor: const Color(0xFFF5F9FC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
        onChanged: (val) {
          final v = double.tryParse(val);
          if (v != null) {
            onChanged(v.clamp(min, max));
          }
          setState(() {});
        },
        validator: (val) {
          if (val == null || val.isEmpty) return 'Required';
          if (double.tryParse(val) == null) return 'Enter a valid number';
          return null;
        },
      ),
    );
  }

  Widget _dateField({
    required String label,
    DateTime? date,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => _selectDate(context, date, onDateSelected),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey.shade500),
            prefixIcon: Icon(Icons.calendar_today, color: Colors.blue.shade400, size: 22),
            prefixIconConstraints: const BoxConstraints(minWidth: 40),
            filled: true,
            fillColor: const Color(0xFFF5F9FC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          ),
          child: Text(
            date == null
                ? 'Select Date'
                : '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
            style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(PatientData p) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [Colors.green.shade500, Colors.teal.shade500],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade300.withOpacity(0.6),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _saveAndNext(p),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Next Step',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [Colors.grey.shade400, Colors.grey.shade600],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300.withOpacity(0.6),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Go Back',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
