import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'patient_data.dart';
import 'patient_details_4.dart';

class PatientDetails3 extends StatefulWidget {
  const PatientDetails3({super.key});

  @override
  State<PatientDetails3> createState() => _PatientDetails3State();
}

class _PatientDetails3State extends State<PatientDetails3> {
  final _formKey = GlobalKey<FormState>();

  late PatientData patient;

  @override
  void initState() {
    super.initState();
    patient = context.read<PatientData>();
  }

  void _saveAndNavigateNext() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      patient.update(); // Notify listeners if needed
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const PatientDetails4()),
      );
    }
  }

  void _navigateBack() {
    Navigator.of(context).pop();
  }

  void _addFamilyMember() {
    setState(() {
      patient.familyMembersWithCancer.add({
        'relation': 'Mother',
        'cancer_type': 'Breast',
        'age_at_diagnosis': null,
      });
    });
  }

  void _removeFamilyMember(int index) {
    setState(() {
      patient.familyMembersWithCancer.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.green.shade50],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildProgressBar(3, 6),
              const SizedBox(height: 20),

              _buildCard(
                title: 'Family Cancer History',
                children: [
                  _buildToggleField(
                    label: 'Anyone in family had cancer?',
                    value: patient.familyCancerHistory,
                    onChanged: (val) {
                      setState(() {
                        patient.familyCancerHistory = val;
                        if (!val) patient.familyMembersWithCancer.clear();
                      });
                    },
                  ),
                  if (patient.familyCancerHistory) ...[
                    const SizedBox(height: 16),
                    ...List.generate(
                        patient.familyMembersWithCancer.length,
                        (index) => _buildFamilyMemberForm(index)),
                    const SizedBox(height: 16),
                    _buildAddFamilyMemberButton(),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              _buildCard(
                title: 'Family Chronic Disease History',
                children: [
                  _buildCheckboxTile(
                    label: 'Diabetes',
                    value: patient.familyDiabetes,
                    onChanged: (val) => setState(() => patient.familyDiabetes = val),
                  ),
                  _buildCheckboxTile(
                    label: 'High Blood Pressure',
                    value: patient.familyHypertension,
                    onChanged: (val) => setState(() => patient.familyHypertension = val),
                  ),
                  _buildCheckboxTile(
                    label: 'Heart Disease',
                    value: patient.familyHeartDisease,
                    onChanged: (val) => setState(() => patient.familyHeartDisease = val),
                  ),
                  _buildCheckboxTile(
                    label: 'Kidney Disease',
                    value: patient.familyKidneyDisease,
                    onChanged: (val) => setState(() => patient.familyKidneyDisease = val),
                  ),
                  _buildCheckboxTile(
                    label: 'Liver Disease',
                    value: patient.familyLiverDisease,
                    onChanged: (val) => setState(() => patient.familyLiverDisease = val),
                  ),
                  _buildCheckboxTile(
                    label: 'Autoimmune Disease',
                    value: patient.familyAutoimmuneDisease,
                    onChanged: (val) => setState(() => patient.familyAutoimmuneDisease = val),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildCard(
                title: 'Genetic Risk Factors',
                children: [
                  _buildToggleField(
                    label: 'Consanguineous marriage in family?',
                    value: patient.consanguineousMarriageInFamily,
                    onChanged: (val) => setState(() => patient.consanguineousMarriageInFamily = val),
                  ),
                  const SizedBox(height: 16),
                  _buildToggleField(
                    label: 'Multiple family members with same cancer?',
                    value: patient.multipleFamilyMembersSameCancer,
                    onChanged: (val) => setState(() => patient.multipleFamilyMembersSameCancer = val),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(child: _buildBackButton()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildNextButton()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(int currentStep, int totalSteps) {
    return Column(
      children: [
        Text('Step $currentStep of $totalSteps',
            style: TextStyle(
                fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: currentStep / totalSteps,
          backgroundColor: Colors.grey.shade300,
          color: const Color(0xFF2563eb),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildToggleField({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF10b981),
        ),
      ],
    );
  }

  Widget _buildCheckboxTile({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      onChanged: (val) => onChanged(val ?? false),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: const Color(0xFF10b981),
    );
  }

  Widget _buildFamilyMemberForm(int index) {
    final member = patient.familyMembersWithCancer[index];
    final relations = ['Mother', 'Father', 'Sibling', 'Grandparent', 'Uncle/Aunt'];
    final cancerTypes = [
      'Breast','Lung','Colorectal','Prostate','Pancreatic','Liver','Stomach','Esophageal',
      'Ovarian','Cervical','Thyroid','Leukemia','Lymphoma','Skin (Melanoma)','Brain','Kidney',
      'Bladder','Other'
    ];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Family Member ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => _removeFamilyMember(index),
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: member['relation'],
              items: relations.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (val) => setState(() => member['relation'] = val),
              decoration: const InputDecoration(labelText: 'Relation'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: member['cancer_type'],
              items: cancerTypes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => member['cancer_type'] = val),
              decoration: const InputDecoration(labelText: 'Cancer Type'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: member['age_at_diagnosis']?.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Age at diagnosis'),
              validator: (val) {
                if (val == null || val.isEmpty) return 'Age is required';
                if (int.tryParse(val) == null) return 'Enter a valid number';
                return null;
              },
              onChanged: (val) => member['age_at_diagnosis'] = int.tryParse(val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddFamilyMemberButton() {
    return ElevatedButton.icon(
      onPressed: _addFamilyMember,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text('Add Family Member', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF10b981),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: _saveAndNavigateNext,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2563eb),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text('Next', style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  Widget _buildBackButton() {
    return OutlinedButton(
      onPressed: _navigateBack,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF2563eb),
        side: const BorderSide(color: Color(0xFF2563eb)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text('Go Back', style: TextStyle(fontSize: 18)),
    );
  }
}
