// patient_details_5.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'patient_data.dart';
import 'patient_details_6.dart';

class PatientDetails5 extends StatefulWidget {
  const PatientDetails5({super.key});

  @override
  State<PatientDetails5> createState() => _PatientDetails5State();
}

class _PatientDetails5State extends State<PatientDetails5>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  XFile? labReportFile;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
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
    );
    if (date != null) onDateSelected(date);
  }

  Color _highlightIfAbnormal(double? value, double min, double max) {
    if (value == null) return Colors.black;
    return (value < min || value > max) ? Colors.red : Colors.black;
  }

  void _saveAndNext(PatientData patientData) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      patientData.update();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PatientDetails6()),
      );
    }
  }

  void _skipAndNext(PatientData patientData) {
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
          appBar: AppBar(
            title: const Text('Lab Results (Latest)'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
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
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _pickLabReport,
            tooltip: 'Upload Lab Report',
            child: const Icon(Icons.upload_file),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _saveAndNext(p),
                    child: const Text('Next'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton(
                    onPressed: () => _skipAndNext(p),
                    child: const Text('Skip if not available'),
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
    return ListView(
      padding: const EdgeInsets.all(16),
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
          label: 'Test Date',
          date: p.lastSugarTestDate,
          onDateSelected: (d) => p.lastSugarTestDate = d,
        ),
      ],
    );
  }

  Widget _cholesterolTab(PatientData p) {
    return ListView(
      padding: const EdgeInsets.all(16),
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
          label: 'Test Date',
          date: p.lastLipidTestDate,
          onDateSelected: (d) => p.lastLipidTestDate = d,
        ),
      ],
    );
  }

  Widget _bpTab(PatientData p) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _numberField(
          label: 'Systolic BP',
          value: (p.bpSystolicLatest ?? 120).toDouble(),
          min: 90,
          max: 200,
          normalRange: '90 - 120',
          onChanged: (v) => p.bpSystolicLatest = v.toInt(),
        ),
        _numberField(
          label: 'Diastolic BP',
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
    );
  }

  Widget _inflammationTab(PatientData p) {
    return ListView(
      padding: const EdgeInsets.all(16),
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
    );
  }

  Widget _cbcTab(PatientData p) {
    return ListView(
      padding: const EdgeInsets.all(16),
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
    );
  }

  Widget _liverTab(PatientData p) {
    return ListView(
      padding: const EdgeInsets.all(16),
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
    );
  }

  Widget _kidneyTab(PatientData p) {
    return ListView(
      padding: const EdgeInsets.all(16),
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
    );
  }

  // ----------------- REUSABLE WIDGETS -----------------

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
        initialValue: value.toString(),
        decoration: InputDecoration(
          labelText: label,
          suffixText: normalRange,
          suffixStyle: const TextStyle(color: Colors.grey),
        ),
        keyboardType: TextInputType.number,
        style: TextStyle(color: color),
        onChanged: (val) {
          final v = double.tryParse(val);
          if (v != null) onChanged(v.clamp(min, max));
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
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          child: Text(date == null
              ? 'Select Date'
              : '${date.day}/${date.month}/${date.year}'),
        ),
      ),
    );
  }
}
