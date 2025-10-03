// patient_details_6.dart
import 'package:chronocancer_ai/features/patient/pages/patient_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'patient_data.dart';

class PatientDetails6 extends StatefulWidget {
  const PatientDetails6({super.key});

  @override
  State<PatientDetails6> createState() => _PatientDetails6State();
}

class _PatientDetails6State extends State<PatientDetails6> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientData>(
      builder: (context, p, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cancer Symptoms Screening'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'GENERAL WARNING SIGNS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),

                // Weight Loss
                _yesNoField(
                  label: 'Lost weight without trying?',
                  value: p.unexplainedWeightLoss6Months,
                  onChanged: (v) {
                    setState(() => p.unexplainedWeightLoss6Months = v);
                  },
                ),
                if (p.unexplainedWeightLoss6Months)
                  Column(
                    children: [
                      const SizedBox(height: 8),
                      Text('How much weight lost? (${p.weightLostKg ?? 1} kg)'),
                      Slider(
                        value: (p.weightLostKg ?? 1).toDouble(),
                        min: 1,
                        max: 20,
                        divisions: 19,
                        label: '${p.weightLostKg ?? 1} kg',
                        onChanged: (v) => setState(() => p.weightLostKg = v.toInt()),
                      ),
                    ],
                  ),

                const SizedBox(height: 16),
                // Fatigue
                _yesNoField(
                  label: 'Persistent tiredness/weakness?',
                  value: p.persistentFatigue,
                  onChanged: (v) => setState(() => p.persistentFatigue = v),
                ),
                if (p.persistentFatigue)
                  TextFormField(
                    initialValue: p.fatigueDurationWeeks?.toString() ?? '',
                    decoration: const InputDecoration(
                        labelText: 'Duration (weeks)', hintText: 'Number of weeks'),
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (p.persistentFatigue) {
                        if (val == null || val.isEmpty) return 'Required';
                        if (int.tryParse(val) == null) return 'Enter a valid number';
                      }
                      return null;
                    },
                    onSaved: (val) =>
                        p.fatigueDurationWeeks = int.tryParse(val ?? '0'),
                  ),

                const SizedBox(height: 16),
                // Lumps/Swellings
                _yesNoField(
                  label: 'Any unusual lumps?',
                  value: p.anyLumpsSwellings,
                  onChanged: (v) => setState(() => p.anyLumpsSwellings = v),
                ),
                if (p.anyLumpsSwellings)
                  _multiSelectField(
                    label: 'Locations',
                    options: const ['Breast', 'Neck', 'Groin', 'Testicles', 'Other'],
                    selectedOptions: p.lumpLocations,
                    onChanged: (v) => setState(() => p.lumpLocations = v),
                  ),

                const SizedBox(height: 16),
                // Bleeding
                _yesNoField(
                  label: 'Unusual bleeding anywhere?',
                  value: p.unusualBleeding,
                  onChanged: (v) => setState(() => p.unusualBleeding = v),
                ),
                if (p.unusualBleeding)
                  _multiSelectField(
                    label: 'Types',
                    options: const ['Stool', 'Urine', 'Coughing', 'Vaginal', 'Rectal'],
                    selectedOptions: p.bleedingTypes,
                    onChanged: (v) => setState(() => p.bleedingTypes = v),
                  ),

                const SizedBox(height: 16),
                // Pain
                _yesNoField(
                  label: 'Persistent pain anywhere?',
                  value: p.persistentPain,
                  onChanged: (v) => setState(() => p.persistentPain = v),
                ),
                if (p.persistentPain)
                  Column(
                    children: [
                      _multiSelectField(
                        label: 'Locations',
                        options: const ['Chest', 'Back', 'Abdomen', 'Bones', 'Pelvis'],
                        selectedOptions: p.painLocations,
                        onChanged: (v) => setState(() => p.painLocations = v),
                      ),
                      TextFormField(
                        initialValue: p.painDurationWeeks?.toString() ?? '',
                        decoration: const InputDecoration(
                            labelText: 'Duration (weeks)', hintText: 'Number of weeks'),
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
                  ),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      p.update();
                      // Navigate to next page
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => NextPage()));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()), // replace NextPage with your widget
                      );
                    }
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _yesNoField({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label)),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _multiSelectField({
    required String label,
    required List<String> options,
    required List<String> selectedOptions,
    required ValueChanged<List<String>> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: options
              .map((opt) => FilterChip(
                    label: Text(opt),
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
                  ))
              .toList(),
        ),
      ],
    );
  }
}
