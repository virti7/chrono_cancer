import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'patient_data.dart';
import 'patient_details_3.dart';
import 'package:chronocancer_ai/features/patient/pages/firestore_service.dart';

class PatientDetails2 extends StatefulWidget {
  const PatientDetails2({super.key});

  @override
  State<PatientDetails2> createState() => _PatientDetails2State();
}

class _PatientDetails2State extends State<PatientDetails2> {
  final _formKey = GlobalKey<FormState>();
  final firestoreService = FirestoreService();

  late int smokingStatus;
  TextEditingController _smokingYearsController = TextEditingController();
  TextEditingController _cigarettesPerDayController = TextEditingController();

  late int alcoholConsumption;
  TextEditingController _drinksPerWeekController = TextEditingController();

  late int physicalActivityHoursPerWeek;

  @override
  void initState() {
    super.initState();
    final patient = context.read<PatientData>();
    smokingStatus = patient.smokingStatus;
    alcoholConsumption = patient.alcoholConsumption;
    physicalActivityHoursPerWeek = patient.physicalActivityHoursPerWeek;

    if (patient.smokingYears != null) {
      _smokingYearsController.text = patient.smokingYears!.toString();
    }
    if (patient.cigarettesPerDay != null) {
      _cigarettesPerDayController.text = patient.cigarettesPerDay!.toString();
    }
    if (patient.drinksPerWeek != null) {
      _drinksPerWeekController.text = patient.drinksPerWeek!.toString();
    }
  }

  @override
  void dispose() {
    _smokingYearsController.dispose();
    _cigarettesPerDayController.dispose();
    _drinksPerWeekController.dispose();
    super.dispose();
  }

  void _saveAndNavigateNext() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final patient = context.read<PatientData>();
      patient.smokingStatus = smokingStatus;
      patient.smokingYears = int.tryParse(_smokingYearsController.text);
      patient.cigarettesPerDay = int.tryParse(_cigarettesPerDayController.text);
      patient.alcoholConsumption = alcoholConsumption;
      patient.drinksPerWeek = int.tryParse(_drinksPerWeekController.text);
      patient.physicalActivityHoursPerWeek = physicalActivityHoursPerWeek;
      patient.update();

      final data = {
        "smoking_status": smokingStatus == 0
            ? "Never"
            : smokingStatus == 1
                ? "Former"
                : "Current",
        "smoking_years": patient.smokingYears,
        "cigarettes_per_day": patient.cigarettesPerDay,
        "alcohol_consumption": alcoholConsumption == 0
            ? "Never"
            : alcoholConsumption == 1
                ? "Occasional"
                : alcoholConsumption == 2
                    ? "Moderate"
                    : "Heavy",
        "drinks_per_week": patient.drinksPerWeek,
        "physical_activity_hours_per_week":
            patient.physicalActivityHoursPerWeek,
      };

      try {
        await firestoreService.updateField("page2_lifestyle", data);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const PatientDetails3()),
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

  void _navigateBack() {
    Navigator.of(context).pop();
  }

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: _navigateBack,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Lifestyle Factors',
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
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 24,
                        ),
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          children: [
            _buildProgressBar(2, 6),
            const SizedBox(height: 30),
            _buildSectionCard(
              title: 'Smoking Status',
              icon: Icons.smoking_rooms_outlined,
              children: [
                _buildChoiceButtons(
                  choices: ['Never', 'Former', 'Current'],
                  selectedIndex: smokingStatus,
                  onSelected: (index) {
                    setState(() {
                      smokingStatus = index;
                      if (index == 0) {
                        _smokingYearsController.clear();
                        _cigarettesPerDayController.clear();
                      }
                    });
                  },
                ),
                if (smokingStatus != 0) ...[
                  const SizedBox(height: 20),
                  _buildNumberField(
                    controller: _smokingYearsController,
                    label: 'Years smoked',
                    icon: Icons.access_time,
                    validator: (val) =>
                        (smokingStatus != 0 && (val == null || val.isEmpty))
                            ? 'Please enter years smoked'
                            : null,
                  ),
                  const SizedBox(height: 20),
                  _buildNumberField(
                    controller: _cigarettesPerDayController,
                    label: 'Cigarettes per day',
                    icon: Icons.local_fire_department_outlined,
                    validator: (val) =>
                        (smokingStatus != 0 && (val == null || val.isEmpty))
                            ? 'Please enter cigarettes per day'
                            : null,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 30),
            _buildSectionCard(
              title: 'Alcohol Consumption',
              icon: Icons.local_bar_outlined,
              children: [
                _buildChoiceButtons(
                  choices: ['Never', 'Occasional', 'Moderate', 'Heavy'],
                  selectedIndex: alcoholConsumption,
                  onSelected: (index) {
                    setState(() {
                      alcoholConsumption = index;
                      if (index == 0) {
                        _drinksPerWeekController.clear();
                      }
                    });
                  },
                ),
                if (alcoholConsumption != 0) ...[
                  const SizedBox(height: 20),
                  _buildNumberField(
                    controller: _drinksPerWeekController,
                    label: 'Drinks per week',
                    icon: Icons.water_drop_outlined,
                    validator: (val) =>
                        (alcoholConsumption != 0 && (val == null || val.isEmpty))
                            ? 'Please enter drinks per week'
                            : null,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 30),
            _buildSectionCard(
              title: 'Physical Activity',
              icon: Icons.fitness_center_outlined,
              children: [
                _buildSliderField(
                  label: 'Hours per week',
                  value: physicalActivityHoursPerWeek.toDouble(),
                  min: 0,
                  max: 20,
                  onChanged: (val) =>
                      setState(() => physicalActivityHoursPerWeek = val.toInt()),
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

  Widget _buildProgressBar(int step, int total) {
    return Column(
      children: [
        Text(
          'Progress: $step of $total steps',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.indigo.shade700,
          ),
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

  Widget _buildChoiceButtons({
    required List<String> choices,
    required int selectedIndex,
    required ValueChanged<int> onSelected,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F9FC),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Row(
            children: List.generate(choices.length, (index) {
              final isSelected = index == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      color:
                          isSelected ? Colors.blue.shade600 : Colors.transparent,
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color:
                                    Colors.blue.shade300.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      choices[index],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
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
        Text(
          '$label: ${value.toInt()}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.blue.shade500,
            inactiveTrackColor: Colors.blue.shade100,
            thumbColor: Colors.blue.shade700,
            overlayColor: Colors.blue.shade100.withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            trackHeight: 6.0,
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: Colors.blue.shade700,
            valueIndicatorTextStyle: const TextStyle(color: Colors.white),
          ),
          child: Slider(
            min: min,
            max: max,
            value: value,
            divisions: (max - min).toInt(),
            onChanged: onChanged,
            label: value.toInt().toString(),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Icon(icon, color: Colors.blue.shade400, size: 22),
        ),
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
      validator: validator,
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
          onTap: _saveAndNavigateNext,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
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
          onTap: _navigateBack,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 24),
                SizedBox(width: 10),
                Text(
                  'Back',
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
    );
  }
}
