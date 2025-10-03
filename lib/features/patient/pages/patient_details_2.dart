import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'patient_data.dart';
import 'patient_details_3.dart';

class PatientDetails2 extends StatefulWidget {
  const PatientDetails2({super.key});

  @override
  State<PatientDetails2> createState() => _PatientDetails2State();
}

class _PatientDetails2State extends State<PatientDetails2> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final patient = context.read<PatientData>();
    smokingStatus = patient.smokingStatus;
    smokingYears = patient.smokingYears;
    cigarettesPerDay = patient.cigarettesPerDay;
    alcoholConsumption = patient.alcoholConsumption;
    drinksPerWeek = patient.drinksPerWeek;
    physicalActivityHoursPerWeek = patient.physicalActivityHoursPerWeek;
  }

  late int smokingStatus;
  int? smokingYears;
  int? cigarettesPerDay;

  late int alcoholConsumption;
  int? drinksPerWeek;

  late int physicalActivityHoursPerWeek;

  void _saveAndNavigateNext() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final patient = context.read<PatientData>();
      patient.smokingStatus = smokingStatus;
      patient.smokingYears = smokingYears;
      patient.cigarettesPerDay = cigarettesPerDay;
      patient.alcoholConsumption = alcoholConsumption;
      patient.drinksPerWeek = drinksPerWeek;
      patient.physicalActivityHoursPerWeek = physicalActivityHoursPerWeek;
      patient.update(); // notify listeners

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const PatientDetails3()),
      );
    }
  }

  void _navigateBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lifestyle Factors'),
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
            const Text('Step 2 of 6', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            _buildSection(
              title: 'Smoking Status',
              child: Row(
                children: [
                  _buildChoiceButton(
                      label: 'Never',
                      selected: smokingStatus == 0,
                      onTap: () {
                        setState(() {
                          smokingStatus = 0;
                          smokingYears = null;
                          cigarettesPerDay = null;
                        });
                      }),
                  _buildChoiceButton(
                      label: 'Former',
                      selected: smokingStatus == 1,
                      onTap: () => setState(() => smokingStatus = 1)),
                  _buildChoiceButton(
                      label: 'Current',
                      selected: smokingStatus == 2,
                      onTap: () => setState(() => smokingStatus = 2)),
                ],
              ),
            ),
            if (smokingStatus != 0) ...[
              const SizedBox(height: 12),
              _buildSliderField(
                  label: 'Years smoked',
                  value: (smokingYears ?? 0).toDouble(),
                  min: 0,
                  max: 60,
                  onChanged: (val) => setState(() => smokingYears = val.toInt())),
              const SizedBox(height: 12),
              _buildNumberField(
                  label: 'Cigarettes per day',
                  value: cigarettesPerDay,
                  onChanged: (val) => setState(() => cigarettesPerDay = val)),
            ],

            const SizedBox(height: 20),
            _buildSection(
              title: 'Alcohol Consumption',
              child: Row(
                children: [
                  _buildChoiceButton(
                      label: 'Never',
                      selected: alcoholConsumption == 0,
                      onTap: () {
                        setState(() {
                          alcoholConsumption = 0;
                          drinksPerWeek = null;
                        });
                      }),
                  _buildChoiceButton(
                      label: 'Occasional',
                      selected: alcoholConsumption == 1,
                      onTap: () => setState(() => alcoholConsumption = 1)),
                  _buildChoiceButton(
                      label: 'Moderate',
                      selected: alcoholConsumption == 2,
                      onTap: () => setState(() => alcoholConsumption = 2)),
                  _buildChoiceButton(
                      label: 'Heavy',
                      selected: alcoholConsumption == 3,
                      onTap: () => setState(() => alcoholConsumption = 3)),
                ],
              ),
            ),
            if (alcoholConsumption != 0) ...[
              const SizedBox(height: 12),
              _buildSliderField(
                  label: 'Drinks per week',
                  value: (drinksPerWeek ?? 0).toDouble(),
                  min: 0,
                  max: 20,
                  onChanged: (val) => setState(() => drinksPerWeek = val.toInt())),
            ],

            const SizedBox(height: 20),
            _buildSection(
              title: 'Physical Activity (hrs/week)',
              child: _buildSliderField(
                  label: 'Hours',
                  value: physicalActivityHoursPerWeek.toDouble(),
                  min: 0,
                  max: 20,
                  onChanged: (val) =>
                      setState(() => physicalActivityHoursPerWeek = val.toInt())),
            ),

            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _navigateBack,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveAndNavigateNext,
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Colors.blue : Colors.grey.shade300,
          foregroundColor: selected ? Colors.white : Colors.black,
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildSliderField({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toInt()}'),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: value.toInt().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    int? value,
    required ValueChanged<int?> onChanged,
  }) {
    return TextFormField(
      keyboardType: TextInputType.number,
      initialValue: value?.toString(),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: (val) => onChanged(int.tryParse(val)),
    );
  }
}
