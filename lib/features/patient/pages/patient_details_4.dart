// patient_details_4.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'patient_data.dart';
import 'patient_details_5.dart';
import 'package:chronocancer_ai/features/patient/pages/firestore_service.dart';

class PatientDetails4 extends StatefulWidget {
  const PatientDetails4({super.key});

  @override
  State<PatientDetails4> createState() => _PatientDetails4State();
}

class _PatientDetails4State extends State<PatientDetails4> {
  final _formKey = GlobalKey<FormState>();
  final firestoreService = FirestoreService();

  void _saveAndNext(PatientData patientData) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      patientData.update();

      final data = {
        "has_diabetes": patientData.hasDiabetes,
        "diabetes_type": patientData.diabetesType,
        "diabetes_duration_years": patientData.diabetesDurationYears,
        "hba1c_latest": patientData.hba1cLatest,
        "fasting_glucose": patientData.fastingGlucose,
        "diabetes_controlled": patientData.diabetesControlled,
        "diabetes_medications": patientData.diabetesMedications,
        "metabolic_syndrome_diagnosed": patientData.metabolicSyndromeDiagnosed,
        "waist_circumference": patientData.waistCircumference,
        "has_hypertension": patientData.hasHypertension,
        "bp_systolic_usual": patientData.bpSystolicUsual,
        "bp_diastolic_usual": patientData.bpDiastolicUsual,
        "hypertension_controlled": patientData.hypertensionControlled,
        "bp_medications": patientData.bpMedications,
        "has_copd": patientData.hasCopd,
        "copd_severity": patientData.copdSeverity,
        "chronic_cough_duration": patientData.chronicCoughDuration,
        "has_asthma": patientData.hasAsthma,
        "asthma_severity": patientData.asthmaSeverity,
      };

      try {
        await firestoreService.updateField("page4_chronic_diseases", data);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PatientDetails5()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save data: $e')),
        );
      }
    }
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientData>(
      builder: (context, patientData, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF0F5F9),
          appBar: AppBar(
            automaticallyImplyLeading: false, // ✅ Fix double arrow
            toolbarHeight: 80,
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade500, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                color: Colors.white, size: 24),
                            onPressed: _goBack,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Chronic Diseases',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ),
                          const Opacity(
                            opacity: 0.0,
                            child: Icon(Icons.arrow_back_ios_new_rounded, size: 24),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Patient Onboarding',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ---------------- Body ----------------
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              children: [
                _buildProgressBar(4, 6),
                const SizedBox(height: 30),

                _buildSectionCard(
                  title: 'Metabolic Conditions',
                  icon: Icons.bloodtype_outlined,
                  children: [
                    _buildCheckboxTile(
                      'Diabetes',
                      patientData.hasDiabetes,
                      (val) => setState(() => patientData.hasDiabetes = val),
                    ),
                    if (patientData.hasDiabetes)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDropdownField(
                            'Type',
                            patientData.diabetesType,
                            ['Type 1', 'Type 2', 'Gestational', 'Prediabetes'],
                            (val) => patientData.diabetesType = val,
                          ),
                          _buildNumberField(
                            'Years with diabetes',
                            patientData.diabetesDurationYears?.toDouble() ?? 0,
                            0,
                            50,
                            (val) => patientData.diabetesDurationYears = val.toInt(),
                          ),
                          _buildNumberField(
                            'Latest HbA1c',
                            patientData.hba1cLatest ?? 6.0,
                            4,
                            14,
                            (val) => patientData.hba1cLatest = val,
                          ),
                          _buildNumberField(
                            'Fasting glucose (mg/dL)',
                            patientData.fastingGlucose?.toDouble() ?? 90,
                            50,
                            400,
                            (val) => patientData.fastingGlucose = val.toInt(),
                          ),
                          _buildChoiceChips(
                            'Control level',
                            ['Well-controlled', 'Moderately', 'Poorly'],
                            patientData.diabetesControlled ?? 'Well-controlled',
                            (val) => patientData.diabetesControlled = val,
                          ),
                          _buildMultiSelectField(
                            'Medications',
                            [
                              'Metformin',
                              'Insulin',
                              'Sulfonylureas',
                              'GLP-1',
                              'SGLT2 inhibitors'
                            ],
                            patientData.diabetesMedications,
                            (list) => patientData.diabetesMedications = list,
                          ),
                        ],
                      ),
                    _buildCheckboxTile(
                      'Obesity / Metabolic Syndrome',
                      patientData.metabolicSyndromeDiagnosed,
                      (val) =>
                          setState(() => patientData.metabolicSyndromeDiagnosed = val),
                    ),
                    if (patientData.metabolicSyndromeDiagnosed)
                      _buildNumberField(
                        'Waist Circumference (cm)',
                        patientData.waistCircumference?.toDouble() ?? 80,
                        50,
                        200,
                        (val) => patientData.waistCircumference = val.toInt(),
                      ),
                    _buildCheckboxTile(
                      'Hypertension',
                      patientData.hasHypertension,
                      (val) => setState(() => patientData.hasHypertension = val),
                    ),
                    if (patientData.hasHypertension)
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildNumberField(
                                  'Systolic BP',
                                  patientData.bpSystolicUsual?.toDouble() ?? 120,
                                  80,
                                  250,
                                  (val) => patientData.bpSystolicUsual = val.toInt(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildNumberField(
                                  'Diastolic BP',
                                  patientData.bpDiastolicUsual?.toDouble() ?? 80,
                                  40,
                                  150,
                                  (val) => patientData.bpDiastolicUsual = val.toInt(),
                                ),
                              ),
                            ],
                          ),
                          _buildChoiceChips(
                            'Control level',
                            ['Well', 'Moderately', 'Poorly'],
                            patientData.hypertensionControlled ?? 'Well',
                            (val) => patientData.hypertensionControlled = val,
                          ),
                          _buildMultiSelectField(
                            'Medications',
                            [
                              'ACE inhibitors',
                              'ARBs',
                              'Beta-blockers',
                              'Calcium blockers',
                              'Diuretics'
                            ],
                            patientData.bpMedications,
                            (list) => patientData.bpMedications = list,
                          ),
                        ],
                      ),
                  ],
                ),

                const SizedBox(height: 30),
                _buildSectionCard(
                  title: 'Respiratory Conditions',
                  icon: Icons.air_outlined,
                  children: [
                    _buildCheckboxTile(
                      'COPD / Chronic Bronchitis',
                      patientData.hasCopd,
                      (val) => setState(() => patientData.hasCopd = val),
                    ),
                    if (patientData.hasCopd)
                      _buildDropdownField(
                        'Severity',
                        patientData.copdSeverity,
                        ['Mild', 'Moderate', 'Severe'],
                        (val) => patientData.copdSeverity = val,
                      ),
                    _buildNumberField(
                      'Chronic Cough Duration (weeks)',
                      double.tryParse(patientData.chronicCoughDuration ?? '0') ?? 0,
                      0,
                      520,
                      (val) =>
                          patientData.chronicCoughDuration = val.toInt().toString(),
                    ),
                    _buildCheckboxTile(
                      'Asthma',
                      patientData.hasAsthma,
                      (val) => setState(() => patientData.hasAsthma = val),
                    ),
                    if (patientData.hasAsthma)
                      _buildDropdownField(
                        'Severity',
                        patientData.asthmaSeverity,
                        ['Mild', 'Moderate', 'Severe'],
                        (val) => patientData.asthmaSeverity = val,
                      ),
                  ],
                ),

                const SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(child: _buildBackButton()),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildNextButton(() => _saveAndNext(patientData)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // -------------------- STYLIZED UI HELPERS --------------------
  Widget _buildProgressBar(int step, int total) {
    return Column(
      children: [
        Text(
          'Progress: $step of $total steps',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.indigo.shade700),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: step / total,
            backgroundColor: const Color(0xFFD6E0E6),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade400),
            minHeight: 12,
          ),
        ),
      ],
    );
  }

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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue.shade700, size: 28),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
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

  Widget _buildCheckboxTile(String label, bool value, ValueChanged<bool> onChanged) {
    return CheckboxListTile(
      title: Text(label, style: const TextStyle(fontSize: 16)),
      value: value,
      onChanged: (val) => onChanged(val ?? false),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.green.shade600,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildNumberField(
      String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return TextFormField(
      initialValue: value.toString(),
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      validator: (val) {
        if (val == null || val.isEmpty) return 'Required';
        if (double.tryParse(val) == null) return 'Enter a valid number';
        return null;
      },
      onChanged: (val) {
        double? v = double.tryParse(val);
        if (v != null) onChanged(v.clamp(min, max));
      },
    );
  }

  Widget _buildDropdownField(
      String label, String? value, List<String> options, ValueChanged<String> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (val) {
        if (val != null) onChanged(val);
      },
    );
  }

  Widget _buildChoiceChips(String label, List<String> options,
      String selectedOption, ValueChanged<String> onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          children: options.map((o) {
            return ChoiceChip(
              label: Text(o),
              selected: selectedOption == o,
              onSelected: (_) => onSelected(o),
              selectedColor: Colors.green.shade200,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMultiSelectField(
      String label,
      List<String> options,
      List<String> selectedOptions,
      ValueChanged<List<String>> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          children: options.map((o) {
            final selected = selectedOptions.contains(o);
            return FilterChip(
              label: Text(o),
              selected: selected,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    selectedOptions.add(o);
                  } else {
                    selectedOptions.remove(o);
                  }
                  onChanged(selectedOptions);
                });
              },
              selectedColor: Colors.green.shade200,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNextButton(VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [Colors.green.shade500, Colors.teal.shade500],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(18),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 24),
                SizedBox(width: 10),
                Text(
                  'Next Step',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5),
                ),
              ],
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
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _goBack,
          borderRadius: BorderRadius.circular(18),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                SizedBox(width: 10),
                Text(
                  'Back',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
