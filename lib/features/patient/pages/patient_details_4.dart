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
      patientData.update(); // Notify listeners

      // Prepare data for Firestore
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
          appBar: AppBar(
            title: const Text('Chronic Diseases'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.green.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildProgressBar(4, 6),

                  const SizedBox(height: 20),

                  // -------------------- METABOLIC CONDITIONS --------------------
                  _buildExpandableCard(
                    title: 'Metabolic Conditions',
                    children: [
                      _buildCheckboxTile(
                        label: 'Diabetes',
                        value: patientData.hasDiabetes,
                        onChanged: (val) =>
                            setState(() => patientData.hasDiabetes = val),
                      ),
                      if (patientData.hasDiabetes)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDropdownField(
                              label: 'Type',
                              value: patientData.diabetesType,
                              options: ['Type 1', 'Type 2', 'Gestational', 'Prediabetes'],
                              onChanged: (val) => patientData.diabetesType = val,
                            ),
                            _buildNumberField(
                              label: 'Years with diabetes',
                              value: patientData.diabetesDurationYears?.toDouble() ?? 0,
                              min: 0,
                              max: 50,
                              onChanged: (val) => patientData.diabetesDurationYears = val.toInt(),
                            ),
                            _buildNumberField(
                              label: 'Latest HbA1c',
                              value: patientData.hba1cLatest ?? 6.0,
                              min: 4,
                              max: 14,
                              onChanged: (val) => patientData.hba1cLatest = val,
                            ),
                            _buildNumberField(
                              label: 'Fasting glucose (mg/dL)',
                              value: patientData.fastingGlucose?.toDouble() ?? 90,
                              min: 50,
                              max: 400,
                              onChanged: (val) => patientData.fastingGlucose = val.toInt(),
                            ),
                            _buildChoiceChips(
                              label: 'Control level',
                              options: ['Well-controlled', 'Moderately', 'Poorly'],
                              selectedOption: patientData.diabetesControlled ?? 'Well-controlled',
                              onSelected: (val) => patientData.diabetesControlled = val,
                            ),
                            _buildMultiSelectField(
                              label: 'Medications',
                              options: ['Metformin', 'Insulin', 'Sulfonylureas', 'GLP-1', 'SGLT2 inhibitors'],
                              selectedOptions: patientData.diabetesMedications,
                              onChanged: (list) => patientData.diabetesMedications = list,
                            ),
                          ],
                        ),
                      _buildCheckboxTile(
                        label: 'Obesity / Metabolic Syndrome',
                        value: patientData.metabolicSyndromeDiagnosed,
                        onChanged: (val) => setState(() => patientData.metabolicSyndromeDiagnosed = val),
                      ),
                      if (patientData.metabolicSyndromeDiagnosed)
                        _buildNumberField(
                          label: 'Waist Circumference (cm)',
                          value: patientData.waistCircumference?.toDouble() ?? 80,
                          min: 50,
                          max: 200,
                          onChanged: (val) => patientData.waistCircumference = val.toInt(),
                        ),
                      _buildCheckboxTile(
                        label: 'Hypertension',
                        value: patientData.hasHypertension,
                        onChanged: (val) => setState(() => patientData.hasHypertension = val),
                      ),
                      if (patientData.hasHypertension)
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildNumberField(
                                    label: 'Systolic BP',
                                    value: patientData.bpSystolicUsual?.toDouble() ?? 120,
                                    min: 80,
                                    max: 250,
                                    onChanged: (val) => patientData.bpSystolicUsual = val.toInt(),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildNumberField(
                                    label: 'Diastolic BP',
                                    value: patientData.bpDiastolicUsual?.toDouble() ?? 80,
                                    min: 40,
                                    max: 150,
                                    onChanged: (val) => patientData.bpDiastolicUsual = val.toInt(),
                                  ),
                                ),
                              ],
                            ),
                            _buildChoiceChips(
                              label: 'Control level',
                              options: ['Well', 'Moderately', 'Poorly'],
                              selectedOption: patientData.hypertensionControlled ?? 'Well',
                              onSelected: (val) => patientData.hypertensionControlled = val,
                            ),
                            _buildMultiSelectField(
                              label: 'Medications',
                              options: ['ACE inhibitors', 'ARBs', 'Beta-blockers', 'Calcium blockers', 'Diuretics'],
                              selectedOptions: patientData.bpMedications,
                              onChanged: (list) => patientData.bpMedications = list,
                            ),
                          ],
                        ),
                    ],
                  ),

                  // -------------------- RESPIRATORY CONDITIONS --------------------
                  _buildExpandableCard(
                    title: 'Respiratory Conditions',
                    children: [
                      _buildCheckboxTile(
                        label: 'COPD / Chronic Bronchitis',
                        value: patientData.hasCopd,
                        onChanged: (val) => setState(() => patientData.hasCopd = val),
                      ),
                      if (patientData.hasCopd)
                        _buildDropdownField(
                          label: 'Severity',
                          value: patientData.copdSeverity,
                          options: ['Mild', 'Moderate', 'Severe'],
                          onChanged: (val) => patientData.copdSeverity = val,
                        ),
                      _buildNumberField(
                        label: 'Chronic Cough Duration (weeks)',
                        value: double.tryParse(patientData.chronicCoughDuration ?? '0') ?? 0,
                        min: 0,
                        max: 520,
                        onChanged: (val) => patientData.chronicCoughDuration = val.toInt().toString(),
                      ),
                      _buildCheckboxTile(
                        label: 'Asthma',
                        value: patientData.hasAsthma,
                        onChanged: (val) => setState(() => patientData.hasAsthma = val),
                      ),
                      if (patientData.hasAsthma)
                        _buildDropdownField(
                          label: 'Severity',
                          value: patientData.asthmaSeverity,
                          options: ['Mild', 'Moderate', 'Severe'],
                          onChanged: (val) => patientData.asthmaSeverity = val,
                        ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _goBack,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2563eb),
                            side: const BorderSide(color: Color(0xFF2563eb)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Go Back', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _saveAndNext(patientData),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563eb),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Next', style: TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // -------------------- UI HELPERS --------------------
  Widget _buildProgressBar(int step, int total) {
    return Column(
      children: [
        Text('Step $step of $total', style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: step / total,
          minHeight: 8,
          backgroundColor: Colors.grey.shade300,
          color: const Color(0xFF2563eb),
        ),
      ],
    );
  }

  Widget _buildExpandableCard({required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Divider(height: 20),
          ...children,
        ]),
      ),
    );
  }

  Widget _buildCheckboxTile({required String label, required bool value, required ValueChanged<bool> onChanged}) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      onChanged: (val) {
        if (val != null) onChanged(val);
      },
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: const Color(0xFF10b981),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildNumberField({required String label, required double value, required double min, required double max, required ValueChanged<double> onChanged}) {
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

  Widget _buildDropdownField({required String label, required String? value, required List<String> options, required ValueChanged<String> onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (val) {
        if (val != null) onChanged(val);
      },
    );
  }

  Widget _buildChoiceChips({required String label, required List<String> options, required String selectedOption, required ValueChanged<String> onSelected}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          children: options.map((o) {
            return ChoiceChip(
              label: Text(o),
              selected: selectedOption == o,
              onSelected: (_) => onSelected(o),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMultiSelectField({required String label, required List<String> options, required List<String> selectedOptions, required ValueChanged<List<String>> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          children: options.map((o) {
            bool selected = selectedOptions.contains(o);
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
            );
          }).toList(),
        ),
      ],
    );
  }
}