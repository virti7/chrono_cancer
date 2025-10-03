// lib/features/doctor/pages/patient_history_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:fl_chart/fl_chart.dart'; // For mini progress chart

class PatientHistoryPage extends StatefulWidget {
  final Map<String, dynamic> patient;
  final int initialTabIndex;

  const PatientHistoryPage({
    Key? key,
    required this.patient,
    this.initialTabIndex = 0,
  }) : super(key: key);

  @override
  _PatientHistoryPageState createState() => _PatientHistoryPageState();
}

class _PatientHistoryPageState extends State<PatientHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<dynamic> _reports;
  late List<Map<String, dynamic>> _timeline;

  String _searchQuery = "";
  bool _sortNewestFirst = true; // 🔄 Sorting toggle

  // Define a color scheme for better UI
  static const Color primaryColor = Color(0xFF673AB7); // Deep Purple
  static const Color accentColor = Color(0xFF8E24AA); // Purple Accent
  static const Color secondaryColor = Color(0xFF00ACC1); // Teal
  static const Color backgroundColor = Color(0xFFF5F7FA); // Light Grey Blue
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF333333); // Dark Grey
  static const Color lightTextColor = Color(0xFF666666); // Medium Grey

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize with dummy data if not present
    _reports = List.from(widget.patient['reports'] ?? [
      {
        "title": "Initial Blood Work",
        "date": "2024-03-01",
        "file": "/path/to/blood_work.pdf",
        "icon": Icons.insert_drive_file,
        "color": secondaryColor,
      },
      {
        "title": "X-Ray Scan",
        "date": "2024-02-20",
        "file": "/path/to/xray.jpg",
        "icon": Icons.image,
        "color": Colors.orange,
      },
    ]);

    _timeline = List<Map<String, dynamic>>.from(widget.patient['timeline'] ?? [
      {
        "date": "2024-03-10",
        "title": "Follow-up Visit - Stable",
        "description": "Patient shows significant improvement. Medication dosage adjusted.",
        "progressData": [130, 128, 125, 120, 118], // BP Example
      },
      {
        "date": "2024-02-15",
        "title": "Medication Prescribed",
        "description": "Started new medication for blood pressure control (Lisinopril 10mg).",
      },
      {
        "date": "2024-01-15",
        "title": "Initial Diagnosis: Hypertension & Type 2 Diabetes",
        "description": "Diagnosed with essential hypertension and Type 2 Diabetes after comprehensive tests.",
        "progressData": [150, 145, 140, 135], // Sugar Level Example (decreasing)
      },
    ]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ---------------- REPORT FUNCTIONS ----------------
  String _suggestReportName(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return "Lab Report";
      case 'jpg':
      case 'jpeg':
      case 'png':
        return "Scan / Image Report";
      default:
        return "Medical Report";
    }
  }

  void _reportDialog({Map<String, dynamic>? existingReport, int? index}) {
    final isEditing = existingReport != null;
    final TextEditingController titleController = TextEditingController(
        text: existingReport?['title']?.toString() ?? '');
    String selectedDate = existingReport?['date']?.toString() ??
        DateFormat("yyyy-MM-dd").format(DateTime.now());
    String? selectedFile = existingReport?['file']?.toString();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(isEditing ? "Edit Report" : "Add Report", style: const TextStyle(color: textColor)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Report Title",
                      labelStyle: TextStyle(color: lightTextColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text("Date: ", style: TextStyle(color: textColor)),
                      Text(selectedDate,
                          style:
                              const TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.tryParse(selectedDate) ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: primaryColor, // header background color
                                    onPrimary: Colors.white, // header text color
                                    onSurface: textColor, // body text color
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: primaryColor, // button text color
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setStateDialog(() {
                              selectedDate =
                                  DateFormat("yyyy-MM-dd").format(picked);
                            });
                          }
                        },
                        child: Text("Change", style: TextStyle(color: secondaryColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: secondaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    icon: const Icon(Icons.attach_file),
                    label: Text(selectedFile == null
                        ? "Upload File"
                        : "Selected: ${selectedFile?.split('/').last ?? "No file"}"),
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                      );
                      if (result != null && result.files.single.path != null) {
                        setStateDialog(() {
                          selectedFile = result.files.single.path;
                          if (titleController.text.isEmpty &&
                              selectedFile != null) {
                            titleController.text =
                                _suggestReportName(selectedFile!);
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Cancel", style: TextStyle(color: lightTextColor)),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(isEditing ? "Update" : "Add"),
                onPressed: () {
                  if (titleController.text.trim().isNotEmpty &&
                      selectedFile != null) {
                    final reportData = {
                      "title": titleController.text.trim(),
                      "date": selectedDate,
                      "file": selectedFile,
                      "icon": Icons.insert_drive_file, // Default icon, can be smarter
                      "color": secondaryColor, // Default color
                    };
                    setState(() {
                      if (isEditing && index != null) {
                        _reports[index] = reportData;
                      } else {
                        _reports.add(reportData);
                      }
                      widget.patient['reports'] = _reports;
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _deleteReport(int index) {
    setState(() {
      _reports.removeAt(index);
      widget.patient['reports'] = _reports;
    });
  }

  void _openReport(dynamic filePath) {
    if (filePath == null) return;
    OpenFilex.open(filePath.toString());
  }

  // ---------------- TIMELINE FUNCTIONS ----------------
  void _timelineDialog({Map<String, dynamic>? existingEvent, int? index}) {
    final isEditing = existingEvent != null;
    final TextEditingController titleController = TextEditingController(
        text: existingEvent?['title']?.toString() ?? '');
    final TextEditingController descController = TextEditingController(
        text: existingEvent?['description']?.toString() ?? '');
    String selectedDate = existingEvent?['date']?.toString() ??
        DateFormat("yyyy-MM-dd").format(DateTime.now());

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(isEditing ? "Edit Timeline Event" : "Add Timeline Event", style: TextStyle(color: textColor)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Event Title",
                      labelStyle: TextStyle(color: lightTextColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: TextStyle(color: lightTextColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text("Date: ", style: TextStyle(color: textColor)),
                      Text(selectedDate,
                          style:
                              const TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.tryParse(selectedDate) ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: primaryColor,
                                    onPrimary: Colors.white,
                                    onSurface: textColor,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: primaryColor,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setStateDialog(() {
                              selectedDate =
                                  DateFormat("yyyy-MM-dd").format(picked);
                            });
                          }
                        },
                        child: Text("Change", style: TextStyle(color: secondaryColor)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Cancel", style: TextStyle(color: lightTextColor)),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: secondaryColor, // Use secondary color for add/update
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(isEditing ? "Update" : "Add"),
                onPressed: () {
                  if (titleController.text.trim().isNotEmpty) {
                    final eventData = {
                      "title": titleController.text.trim(),
                      "description": descController.text.trim(),
                      "date": selectedDate,
                    };
                    setState(() {
                      if (isEditing && index != null) {
                        _timeline[index] = eventData;
                      } else {
                        _timeline.add(eventData);
                      }
                      widget.patient['timeline'] = _timeline;
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _deleteTimelineEvent(int index) {
    setState(() {
      _timeline.removeAt(index);
      widget.patient['timeline'] = _timeline;
    });
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0, // Removed shadow for a flatter look
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: primaryColor),
            ),
            const SizedBox(width: 12),
            Text(
              widget.patient['name']?.toString() ?? "Unknown",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          indicatorWeight: 4, // Thicker indicator
          tabs: const [
            Tab(text: "Overview", icon: Icon(Icons.person_outline)),
            Tab(text: "Reports", icon: Icon(Icons.description_outlined)),
            Tab(text: "Timeline", icon: Icon(Icons.timeline)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildReportsTab(),
          _buildTimelineTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () => _reportDialog(),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : _tabController.index == 2
              ? FloatingActionButton(
                  backgroundColor: secondaryColor,
                  onPressed: () => _timelineDialog(),
                  child: const Icon(Icons.add, color: Colors.white),
                )
              : null,
    );
  }

  // ---------------- OVERVIEW TAB ----------------
  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _overviewCard(
            "Patient ID", widget.patient['id']?.toString() ?? "N/A", Icons.badge),
        _overviewCard("Condition", widget.patient['type']?.toString() ?? "N/A",
            Icons.medical_services),
        _overviewCard(
            "Risk Score",
            widget.patient['riskScore'] != null
                ? "${widget.patient['riskScore']}%"
                : "N/A",
            Icons.warning_amber),
        _overviewCard("Harmony Score",
            widget.patient['harmonyScore']?.toString() ?? "Not Available",
            Icons.favorite),
        _overviewCard("Last Visit", widget.patient['lastVisit']?.toString() ?? "N/A",
            Icons.calendar_today),
      ],
    );
  }

  Widget _overviewCard(String label, String value, IconData icon) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4, // Slightly higher elevation
      shadowColor: Colors.grey.withOpacity(0.2),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primaryColor.withOpacity(0.1),
          child: Icon(icon, color: primaryColor),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, color: lightTextColor)),
      ),
    );
  }

  // ---------------- REPORTS TAB ----------------
  Widget _buildReportsTab() {
    if (_reports.isEmpty) {
      return Center(
        child: Text("No reports available", style: TextStyle(color: lightTextColor)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _reports.length,
      itemBuilder: (context, index) {
        final report = _reports[index] as Map<String, dynamic>? ?? {};
        final String title = report['title']?.toString() ?? "Untitled Report";
        final String uploadedOn = report['date']?.toString() ?? "Unknown";
        final String fileName =
            report['file']?.toString().split('/').last ?? "No file attached";

        return Card(
          color: cardColor,
          elevation: 4,
          shadowColor: Colors.grey.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (report['color'] as Color? ?? Colors.blue).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  report['icon'] as IconData? ?? Icons.description,
                  color: report['color'] ?? Colors.blue,
                  size: 28,
                ),
              ),
              title: Text(title,
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Uploaded on $uploadedOn", style: TextStyle(color: lightTextColor.withOpacity(0.8))),
                  if (report['file'] != null)
                    Text("File: $fileName", style: TextStyle(color: secondaryColor.withOpacity(0.9), fontSize: 13)),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.visibility, color: primaryColor.withOpacity(0.8)),
                    tooltip: "View Report",
                    onPressed: () {
                      if (report['file'] != null) _openReport(report['file']);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.orange.withOpacity(0.8)),
                    tooltip: "Edit Report",
                    onPressed: () =>
                        _reportDialog(existingReport: report, index: index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.withOpacity(0.8)),
                    tooltip: "Delete Report",
                    onPressed: () => _deleteReport(index),
                  ),
                ],
              ),
              onTap: () {
                 if (report['file'] != null) _openReport(report['file']);
              },
            ),
          ),
        );
      },
    );
  }

  // ---------------- TIMELINE TAB ----------------
  Widget _buildTimelineTab() {
    if (_timeline.isEmpty) {
      return Center(
        child: Text("No timeline events available", style: TextStyle(color: lightTextColor)),
      );
    }

    List<Map<String, dynamic>> sortedTimeline = List.from(_timeline);
    sortedTimeline.sort((a, b) {
      DateTime da = DateTime.tryParse(a['date'] ?? '') ?? DateTime(2000);
      DateTime db = DateTime.tryParse(b['date'] ?? '') ?? DateTime(2000);
      return _sortNewestFirst ? db.compareTo(da) : da.compareTo(db);
    });

    final visibleEvents = _searchQuery.isEmpty
        ? sortedTimeline
        : sortedTimeline
            .where((e) =>
                (e['title'] ?? "")
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                (e['description'] ?? "")
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
            .toList();

    int totalTreatments = _timeline
        .where((e) => (e['title']?.toLowerCase().contains("treatment") ?? false))
        .length;

    return Column(
      children: [
        // 🔍 Search bar & Sort button
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: lightTextColor),
                    hintText: "Search events...",
                    hintStyle: TextStyle(color: lightTextColor.withOpacity(0.7)),
                    filled: true,
                    fillColor: cardColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none), // No border for cleaner look
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                  style: const TextStyle(color: textColor),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _sortNewestFirst = !_sortNewestFirst;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        _sortNewestFirst ? "Newest" : "Oldest",
                        style: const TextStyle(color: textColor, fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _sortNewestFirst ? Icons.arrow_downward : Icons.arrow_upward,
                        color: lightTextColor,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Analytics Cards
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              _buildAnalyticsCard("Total Treatments", "$totalTreatments", secondaryColor),
              _buildAnalyticsCard("Avg. Harmony Score", "8.5", primaryColor),
              _buildAnalyticsCard("Last 30 Days Activity", "5 Events", Colors.orange),
              // Add more relevant analytics here
            ],
          ),
        ),

        const Divider(height: 24, thickness: 1, indent: 16, endIndent: 16, color: Colors.grey),

        // Timeline events
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: visibleEvents.length,
            itemBuilder: (context, index) {
              final event = visibleEvents[index];
              final String title = event['title'] ?? "Untitled";
              final String desc = event['description'] ?? "No description";
              final String dateStr = event['date'] ?? "Unknown";
              final List<dynamic>? progressData = event['progressData'];

              return IntrinsicHeight( // Ensure rows take up necessary height
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children vertically
                  children: [
                    // Timeline dot + line
                    Column(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            border: Border.all(color: Colors.white, width: 3), // White ring
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: secondaryColor.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                        ),
                        if (index != visibleEvents.length - 1)
                          Expanded( // Make the line extend
                            child: Container(
                              width: 2,
                              color: lightTextColor.withOpacity(0.4), // Softer line color
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),

                    // Event card
                    Expanded(
                      child: Card(
                        color: cardColor,
                        elevation: 4,
                        shadowColor: Colors.grey.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.only(bottom: 16), // More space between cards
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title + date + actions
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                                color: textColor)),
                                        const SizedBox(height: 4),
                                        Text(dateStr,
                                            style: const TextStyle(
                                                color: lightTextColor, fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.orange.withOpacity(0.8), size: 20),
                                        tooltip: "Edit Event",
                                        onPressed: () => _timelineDialog(
                                            existingEvent: event, index: index),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red.withOpacity(0.8), size: 20),
                                        tooltip: "Delete Event",
                                        onPressed: () => _deleteTimelineEvent(index),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(desc, style: const TextStyle(color: lightTextColor, fontSize: 14)),
                              const SizedBox(height: 12),

                              // Progress chart (only if data exists)
                              if (progressData != null && progressData.isNotEmpty)
                                _buildMiniProgressChart(progressData),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(String title, String value, Color color) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      shadowColor: Colors.grey.withOpacity(0.1),
      margin: const EdgeInsets.only(right: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 13, color: lightTextColor)),
          ],
        ),
      ),
    );
  }
  Widget _buildMiniProgressChart(List<dynamic> data) {
  if (data.isEmpty) {
    return const SizedBox.shrink();
  }

  // Convert your data to spots
  final spots = data.asMap().entries.map((e) {
    return FlSpot(e.key.toDouble(), (e.value as num).toDouble());
  }).toList();

  final double minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
  final double maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);

  return Padding(
    padding: const EdgeInsets.only(left: 6, bottom: 6, right: 12),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05), // replace with your primaryColor
        borderRadius: BorderRadius.circular(8),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(enabled: false), // ✅ FIXED
          minX: 0,
          maxX: spots.length.toDouble() - 1,
          minY: minY < 0 ? 0 : minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.green, // replace with your secondaryColor
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: Colors.green,
                    strokeColor: Colors.white,
                    strokeWidth: 1,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.green.withOpacity(0.3),
                    Colors.green.withOpacity(0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
 }
}
