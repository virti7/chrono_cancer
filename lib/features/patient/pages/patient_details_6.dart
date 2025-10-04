// patient_details_6.dart
import 'package:chronocancer_ai/features/patient/pages/patient_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'patient_data.dart';
import 'package:chronocancer_ai/features/patient/pages/firestore_service.dart';

class PatientDetails6 extends StatefulWidget {
  const PatientDetails6({super.key});

  @override
  State<PatientDetails6> createState() => _PatientDetails6State();
}

class _PatientDetails6State extends State<PatientDetails6> {
  final _formKey = GlobalKey<FormState>();
  final firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = Colors.indigo; // Updated to match page4
    final accentColor = Colors.blue;    // Updated to match page4
    final textColor = Colors.black87;

    return Consumer<PatientData>(
      builder: (context, p, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF0F5F9),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 150,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, accentColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 26),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                            child: const Text(
                              'Cancer Symptoms Screening',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // --- Progress bar with "Progress: 6 of 6 steps" text ---
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress: 6 of 6 steps',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          value: 6 / 6, // full progress
                          minHeight: 10,
                          backgroundColor: Colors.white.withOpacity(0.4),
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                _buildSectionCard(
                  title: 'GENERAL WARNING SIGNS',
                  icon: Icons.warning_amber_outlined,
                  primaryColor: primaryColor,
                  textColor: textColor,
                  accentColor: Colors.green,
                  children: [
                    _yesNoFieldCard(
                      label: 'Lost weight without trying?',
                      value: p.unexplainedWeightLoss6Months,
                      onChanged: (v) => setState(() => p.unexplainedWeightLoss6Months = v),
                      accentColor: Colors.green,
                      textColor: textColor,
                      extraWidget: p.unexplainedWeightLoss6Months
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                Text('How much weight lost? (${p.weightLostKg ?? 1} kg)',
                                    style: TextStyle(fontSize: 15, color: textColor)),
                                Slider(
                                  value: (p.weightLostKg ?? 1).toDouble(),
                                  min: 1,
                                  max: 20,
                                  divisions: 19,
                                  label: '${p.weightLostKg ?? 1} kg',
                                  onChanged: (v) => setState(() => p.weightLostKg = v.toInt()),
                                  activeColor: Colors.green,
                                  inactiveColor: Colors.green.withOpacity(0.3),
                                ),
                              ],
                            )
                          : null,
                    ),
                    const Divider(height: 24, thickness: 1, color: Color(0xFFE0E6EE)),
                    _yesNoFieldCard(
                      label: 'Persistent tiredness/weakness?',
                      value: p.persistentFatigue,
                      onChanged: (v) => setState(() => p.persistentFatigue = v),
                      accentColor: Colors.green,
                      textColor: textColor,
                      extraWidget: p.persistentFatigue
                          ? Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: TextFormField(
                                initialValue: p.fatigueDurationWeeks?.toString() ?? '',
                                decoration: InputDecoration(
                                  labelText: 'Duration (weeks)',
                                  hintText: 'Number of weeks',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: primaryColor, width: 2),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (val) {
                                  if (p.persistentFatigue) {
                                    if (val == null || val.isEmpty) return 'Required';
                                    if (int.tryParse(val) == null) return 'Enter a valid number';
                                  }
                                  return null;
                                },
                                onSaved: (val) => p.fatigueDurationWeeks = int.tryParse(val ?? '0'),
                              ),
                            )
                          : null,
                    ),
                    const Divider(height: 24, thickness: 1, color: Color(0xFFE0E6EE)),
                    _yesNoFieldCard(
                      label: 'Any unusual lumps?',
                      value: p.anyLumpsSwellings,
                      onChanged: (v) => setState(() => p.anyLumpsSwellings = v),
                      accentColor: Colors.green,
                      textColor: textColor,
                      extraWidget: p.anyLumpsSwellings
                          ? Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: _multiSelectField(
                                label: 'Locations',
                                options: const ['Breast', 'Neck', 'Groin', 'Testicles', 'Other'],
                                selectedOptions: p.lumpLocations,
                                accentColor: Colors.green,
                                textColor: textColor,
                                onChanged: (v) => setState(() => p.lumpLocations = v),
                              ),
                            )
                          : null,
                    ),
                    const Divider(height: 24, thickness: 1, color: Color(0xFFE0E6EE)),
                    _yesNoFieldCard(
                      label: 'Unusual bleeding anywhere?',
                      value: p.unusualBleeding,
                      onChanged: (v) => setState(() => p.unusualBleeding = v),
                      accentColor: Colors.green,
                      textColor: textColor,
                      extraWidget: p.unusualBleeding
                          ? Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: _multiSelectField(
                                label: 'Types',
                                options: const ['Stool', 'Urine', 'Coughing', 'Vaginal', 'Rectal'],
                                selectedOptions: p.bleedingTypes,
                                accentColor: Colors.green,
                                textColor: textColor,
                                onChanged: (v) => setState(() => p.bleedingTypes = v),
                              ),
                            )
                          : null,
                    ),
                    const Divider(height: 24, thickness: 1, color: Color(0xFFE0E6EE)),
                    _yesNoFieldCard(
                      label: 'Persistent pain anywhere?',
                      value: p.persistentPain,
                      onChanged: (v) => setState(() => p.persistentPain = v),
                      accentColor: Colors.green,
                      textColor: textColor,
                      extraWidget: p.persistentPain
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: _multiSelectField(
                                    label: 'Locations',
                                    options: const ['Chest', 'Back', 'Abdomen', 'Bones', 'Pelvis'],
                                    selectedOptions: p.painLocations,
                                    accentColor: Colors.green,
                                    textColor: textColor,
                                    onChanged: (v) => setState(() => p.painLocations = v),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  initialValue: p.painDurationWeeks?.toString() ?? '',
                                  decoration: InputDecoration(
                                    labelText: 'Duration (weeks)',
                                    hintText: 'Number of weeks',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: primaryColor, width: 2),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (val) {
                                    if (p.persistentPain) {
                                      if (val == null || val.isEmpty) return 'Required';
                                      if (int.tryParse(val) == null) return 'Enter a valid number';
                                    }
                                    return null;
                                  },
                                  onSaved: (val) => p.painDurationWeeks = int.tryParse(val ?? '0'),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: _buildBackButton(),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildNextButton(() {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          p.update();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const HomePage()));
                        }
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // ----------------- REUSABLE WIDGETS -----------------
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    required Color primaryColor,
    required Color textColor,
    required Color accentColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 30),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                ),
              ),
            ],
          ),
          const Divider(height: 25, thickness: 1.2, color: Color(0xFFE0E6EE)),
          ...children,
        ],
      ),
    );
  }

  Widget _yesNoFieldCard({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color accentColor,
    required Color textColor,
    Widget? extraWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: TextStyle(fontSize: 16.5, color: textColor))),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: accentColor,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
            ),
          ],
        ),
        if (extraWidget != null) extraWidget,
      ],
    );
  }

  Widget _multiSelectField({
    required String label,
    required List<String> options,
    required List<String> selectedOptions,
    required ValueChanged<List<String>> onChanged,
    required Color accentColor,
    required Color textColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options
              .map((opt) => FilterChip(
                    label: Text(opt,
                        style: TextStyle(
                            color: selectedOptions.contains(opt) ? Colors.white : Colors.black87,
                            fontSize: 14)),
                    selected: selectedOptions.contains(opt),
                    onSelected: (v) {
                      final newList = List<String>.from(selectedOptions);
                      if (v) {
                        if (!newList.contains(opt)) newList.add(opt);
                      } else {
                        newList.remove(opt);
                      }
                      onChanged(newList);
                    },
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: accentColor,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                          color: selectedOptions.contains(opt) ? accentColor : Colors.grey.shade300,
                          width: 1.2),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildNextButton(VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [Colors.green, Colors.teal],
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
          colors: [Colors.grey, Colors.grey.shade600],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context),
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