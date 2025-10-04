// patient_details_3.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'patient_data.dart';
import 'patient_details_4.dart';
import 'package:chronocancer_ai/features/patient/pages/firestore_service.dart';

class PatientDetails3 extends StatefulWidget {
  const PatientDetails3({super.key});

  @override
  State<PatientDetails3> createState() => _PatientDetails3State();
}

class _PatientDetails3State extends State<PatientDetails3> {
  final _formKey = GlobalKey<FormState>();
  final firestoreService = FirestoreService();
  late PatientData patient;

  @override
  void initState() {
    super.initState();
    patient = context.read<PatientData>();
  }

  // ---------------- SAVE AND NEXT ----------------
  void _saveAndNavigateNext() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      patient.update(); // notify listeners

      final data = {
        "family_cancer_history": patient.familyCancerHistory,
        "family_members_with_cancer": patient.familyMembersWithCancer,
        "family_diabetes": patient.familyDiabetes,
        "family_hypertension": patient.familyHypertension,
        "family_heart_disease": patient.familyHeartDisease,
        "family_kidney_disease": patient.familyKidneyDisease,
        "family_liver_disease": patient.familyLiverDisease,
        "family_autoimmune_disease": patient.familyAutoimmuneDisease,
        "consanguineous_marriage_in_family": patient.consanguineousMarriageInFamily,
        "multiple_family_members_same_cancer": patient.multipleFamilyMembersSameCancer,
      };

      try {
        await firestoreService.updateField("page3_family_history", data);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PatientDetails4()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save data: $e')),
        );
      }
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

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F5F9),
      appBar: AppBar(
        automaticallyImplyLeading: false, // ✅ Fix duplicate arrow
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.indigo.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 24),
                        onPressed: _navigateBack,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Family History',
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
                    fontWeight: FontWeight.w400,
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
            _buildProgressBar(3, 6),
            const SizedBox(height: 30),

            _buildSectionCard(
              title: 'Family Cancer History',
              icon: Icons.family_restroom_outlined,
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
                    (index) => _buildFamilyMemberForm(index),
                  ),
                  const SizedBox(height: 16),
                  _buildAddFamilyMemberButton(),
                ],
              ],
            ),

            const SizedBox(height: 30),
            _buildSectionCard(
              title: 'Family History',
              icon: Icons.medical_information_outlined,
              children: [
                _buildCheckboxTile(
                    'Diabetes', patient.familyDiabetes,
                    (val) => setState(() => patient.familyDiabetes = val)),
                _buildCheckboxTile(
                    'High Blood Pressure', patient.familyHypertension,
                    (val) => setState(() => patient.familyHypertension = val)),
                _buildCheckboxTile(
                    'Heart Disease', patient.familyHeartDisease,
                    (val) => setState(() => patient.familyHeartDisease = val)),
                _buildCheckboxTile(
                    'Kidney Disease', patient.familyKidneyDisease,
                    (val) => setState(() => patient.familyKidneyDisease = val)),
                _buildCheckboxTile(
                    'Liver Disease', patient.familyLiverDisease,
                    (val) => setState(() => patient.familyLiverDisease = val)),
                _buildCheckboxTile(
                    'Autoimmune Disease', patient.familyAutoimmuneDisease,
                    (val) =>
                        setState(() => patient.familyAutoimmuneDisease = val)),
              ],
            ),

            const SizedBox(height: 30),
            _buildSectionCard(
              title: 'Genetic Risk Factors',
              icon: Icons.biotech_outlined,
              children: [
                _buildToggleField(
                  label: 'Consanguineous marriage in family?',
                  value: patient.consanguineousMarriageInFamily,
                  onChanged: (val) => setState(
                      () => patient.consanguineousMarriageInFamily = val),
                ),
                const SizedBox(height: 16),
                _buildToggleField(
                  label: 'Multiple family members with same cancer?',
                  value: patient.multipleFamilyMembersSameCancer,
                  onChanged: (val) => setState(
                      () => patient.multipleFamilyMembersSameCancer = val),
                ),
              ],
            ),

            const SizedBox(height: 50),
            Row(
              children: [
                Expanded(child: _buildBackButton()),
                const SizedBox(width: 20),
                Expanded(child: _buildNextButton()),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ------------------- Widget Builders -------------------
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
            valueColor:
                AlwaysStoppedAnimation<Color>(Colors.green.shade400),
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
        border: Border.all(color: Colors.grey.shade100, width: 1),
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

  Widget _buildToggleField({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.green.shade600,
        ),
      ],
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

  Widget _buildFamilyMemberForm(int index) {
    final member = patient.familyMembersWithCancer[index];
    final relations = ['Mother', 'Father', 'Sibling', 'Grandparent', 'Uncle/Aunt'];
    final cancerTypes = [
      'Breast','Lung','Colorectal','Prostate','Pancreatic','Liver','Stomach',
      'Esophageal','Ovarian','Cervical','Thyroid','Leukemia','Lymphoma',
      'Skin (Melanoma)','Brain','Kidney','Bladder','Other'
    ];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Family Member ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.redAccent),
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
      label: const Text('Add Family Member',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade600,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildNextButton() {
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
          onTap: _saveAndNavigateNext,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
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
          onTap: _navigateBack,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
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
