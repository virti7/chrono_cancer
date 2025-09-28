import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const BloodPressureApp());
}

class BloodPressureApp extends StatelessWidget {
  const BloodPressureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Pressure Entry',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BloodPressureEntryScreen(),
    );
  }
}

class BloodPressureEntryScreen extends StatefulWidget {
  const BloodPressureEntryScreen({super.key});

  @override
  _BloodPressureEntryScreenState createState() =>
      _BloodPressureEntryScreenState();
}

class _BloodPressureEntryScreenState extends State<BloodPressureEntryScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController _systolicController = TextEditingController(text: '120');
  TextEditingController _diastolicController = TextEditingController(text: '80');
  TextEditingController _notesController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _systolicController.addListener(_updatePreview);
    _diastolicController.addListener(_updatePreview);
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updatePreview() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM dd, yyyy').format(_selectedDate);
    String formattedTime = _selectedTime.format(context);

    int systolic = int.tryParse(_systolicController.text) ?? 0;
    int diastolic = int.tryParse(_diastolicController.text) ?? 0;

    String bpStatus = 'Normal';
    Color bpStatusColor = Colors.green;

    if (systolic > 120 || diastolic > 80) {
      bpStatus = 'High';
      bpStatusColor = Colors.red;
    }
    if (systolic < 90 || diastolic < 60) {
      bpStatus = 'Low';
      bpStatusColor = Colors.orange;
    }
    if (systolic >= 120 && systolic <= 129 && diastolic < 80) {
      bpStatus = 'Elevated';
      bpStatusColor = Colors.orange;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blood Pressure Entry',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFF2196F3),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20, top: 20),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(Icons.calendar_today, 'Date & Time of Measurement'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateTimeCard(
                            icon: Icons.calendar_today,
                            text: formattedDate,
                            onTap: () => _selectDate(context),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildDateTimeCard(
                            icon: Icons.access_time,
                            text: formattedTime,
                            onTap: () => _selectTime(context),
                            hasInfo: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    _buildSectionHeader(Icons.favorite_border, 'Blood Pressure Readings'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildReadingInput(
                            controller: _systolicController,
                            label: 'Systolic',
                            unit: 'mmHg',
                            color: const Color(0xFF64B5F6),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildReadingInput(
                            controller: _diastolicController,
                            label: 'Diastolic',
                            unit: 'mmHg',
                            color: const Color(0xFF81C784),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Notes (Optional)',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 25),
                    _buildSectionHeader(Icons.show_chart, 'Live Preview', iconColor: Colors.blueAccent),
                    const SizedBox(height: 10),
                    _buildLivePreviewCard(
                      systolic: systolic,
                      diastolic: diastolic,
                      status: bpStatus,
                      statusColor: bpStatusColor,
                      date: formattedDate,
                      time: formattedTime,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          print(
                              'Date: $_selectedDate, Time: $_selectedTime, Systolic: ${_systolicController.text}, Diastolic: ${_diastolicController.text}, Notes: ${_notesController.text}');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Save BP Entry',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, {Color iconColor = Colors.red}) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDateTimeCard({required IconData icon, required String text, required VoidCallback onTap, bool hasInfo = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasInfo)
              Icon(Icons.info_outline, color: Colors.grey[400], size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingInput({required TextEditingController controller, required String label, required String unit, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color.darken(0.3),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: IntrinsicWidth(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: color.darken(0.4),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLivePreviewCard({required int systolic, required int diastolic, required String status, required Color statusColor, required String date, required String time}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF64B5F6), Color(0xFF2196F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$systolic / $diastolic mmHg',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            '$date • $time',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
