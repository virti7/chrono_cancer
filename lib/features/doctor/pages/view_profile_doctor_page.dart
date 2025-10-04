import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import for image picking
import 'dart:io'; // Import for File
import 'doctor_profile_page.dart'; // Assuming DoctorDetail is defined here
import 'package:chronocancer_ai/features/auth/pages/role_selection_page.dart'; // For UserSelectionPage

// --- START: Simple Doctor Data Manager (for demonstration) ---
// In a real app, you would use a state management solution (Provider, Riverpod, BLoC)
// and a proper data persistence solution (shared_preferences, Hive, database, API).
class DoctorDataManager extends ChangeNotifier {
  DoctorDetail? _currentDoctor;

  DoctorDetail? get currentDoctor => _currentDoctor;

  void setDoctor(DoctorDetail doctor) {
    _currentDoctor = doctor;
    notifyListeners();
  }

  void updateDoctor({
    String? name,
    String? specialty,
    String? hospital,
    String? bio,
    String? imageUrl,
    List<String>? services,
  }) {
    if (_currentDoctor == null) return;
    _currentDoctor = DoctorDetail(
      name: name ?? _currentDoctor!.name,
      specialty: specialty ?? _currentDoctor!.specialty,
      hospital: hospital ?? _currentDoctor!.hospital,
      bio: bio ?? _currentDoctor!.bio,
      imageUrl: imageUrl ?? _currentDoctor!.imageUrl,
      services: services ?? _currentDoctor!.services,
      rating: _currentDoctor!.rating, // Rating is not editable in this example
    );
    notifyListeners();
  }
}

// Global instance (simplified, use Provider for better practice)
final doctorDataManager = DoctorDataManager();
// --- END: Simple Doctor Data Manager ---

// Define your DoctorDetail if not already in doctor_profile_page.dart
// class DoctorDetail {
//   final String name;
//   final String specialty;
//   final String hospital;
//   final double rating;
//   final String bio;
//   final String imageUrl;
//   final List<String> services;

//   DoctorDetail({
//     required this.name,
//     required this.specialty,
//     required this.hospital,
//     required this.rating,
//     required this.bio,
//     required this.imageUrl,
//     required this.services,
//   });
// }


class ViewProfileDoctorPage extends StatefulWidget {
  final DoctorDetail doctor;

  const ViewProfileDoctorPage({super.key, required this.doctor});

  @override
  State<ViewProfileDoctorPage> createState() => _ViewProfileDoctorPageState();
}

class _ViewProfileDoctorPageState extends State<ViewProfileDoctorPage> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _specialtyController;
  late TextEditingController _hospitalController;
  late TextEditingController _bioController;
  File? _imageFile; // To store selected image file

  @override
  void initState() {
    super.initState();
    // Initialize the global data manager with the provided doctor for the first time
    if (doctorDataManager.currentDoctor == null) {
      doctorDataManager.setDoctor(widget.doctor);
    }
    _initControllers(doctorDataManager.currentDoctor!);
    doctorDataManager.addListener(_onDoctorDataChanged); // Listen for updates
  }

  void _initControllers(DoctorDetail doctor) {
    _nameController = TextEditingController(text: doctor.name);
    _specialtyController = TextEditingController(text: doctor.specialty);
    _hospitalController = TextEditingController(text: doctor.hospital);
    _bioController = TextEditingController(text: doctor.bio);
  }

  void _onDoctorDataChanged() {
    if (doctorDataManager.currentDoctor != null) {
      _nameController.text = doctorDataManager.currentDoctor!.name;
      _specialtyController.text = doctorDataManager.currentDoctor!.specialty;
      _hospitalController.text = doctorDataManager.currentDoctor!.hospital;
      _bioController.text = doctorDataManager.currentDoctor!.bio;
      // You might need to refresh the image if imageUrl changes
      setState(() {}); // Rebuild the widget to reflect changes
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _hospitalController.dispose();
    _bioController.dispose();
    doctorDataManager.removeListener(_onDoctorDataChanged);
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // When exiting edit mode, save changes
        _saveChanges();
      }
    });
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      doctorDataManager.updateDoctor(
        name: _nameController.text,
        specialty: _specialtyController.text,
        hospital: _hospitalController.text,
        bio: _bioController.text,
        imageUrl: _imageFile?.path, // Save local path for now. In real app, upload and save URL.
        // Services would need a more complex editing mechanism (e.g., list of text fields)
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDoctor = doctorDataManager.currentDoctor!; // Get current data from manager

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Doctor Profile",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit, color: _isEditing ? Theme.of(context).colorScheme.secondary : null),
            onPressed: _toggleEditMode,
            tooltip: _isEditing ? "Save Changes" : "Edit Profile",
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => UserSelectionPage()),
                (route) => false,
              );
            },
            tooltip: "Logout",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              GestureDetector(
                onTap: _isEditing ? _pickImage : null,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : NetworkImage(currentDoctor.imageUrl) as ImageProvider,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      child: _imageFile == null && currentDoctor.imageUrl.isEmpty
                          ? Icon(Icons.person, size: 60, color: Theme.of(context).colorScheme.primary)
                          : null,
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Name
              _isEditing
                  ? TextFormField(
                      controller: _nameController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: "Doctor's Name",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    )
                  : Text(
                      currentDoctor.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),

              const SizedBox(height: 8),
              // Specialty
              _isEditing
                  ? TextFormField(
                      controller: _specialtyController,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      decoration: InputDecoration(
                        hintText: "Specialty",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                    )
                  : Text(
                      currentDoctor.specialty,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
              // Hospital
              _isEditing
                  ? TextFormField(
                      controller: _hospitalController,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      decoration: InputDecoration(
                        hintText: "Hospital",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                    )
                  : Text(
                      currentDoctor.hospital,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),

              const SizedBox(height: 12),

              // Rating (not editable in this example)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    "${currentDoctor.rating.toStringAsFixed(1)} / 5.0",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              const Divider(height: 30, thickness: 1, color: Color(0xFFE0E0E0)), // Lighter divider

              // Bio
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "About",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 6),
              _isEditing
                  ? TextFormField(
                      controller: _bioController,
                      maxLines: null, // Allows multiline input
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                      decoration: InputDecoration(
                        hintText: "Write a short bio...",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    )
                  : Text(
                      currentDoctor.bio,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),

              const Divider(height: 30, thickness: 1, color: Color(0xFFE0E0E0)),

              // Services (for simplicity, not editable with text fields here)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Services",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 6),
              Column(
                children: currentDoctor.services.map((service) {
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      leading: Icon(Icons.medical_services_outlined, color: Theme.of(context).colorScheme.primary),
                      title: Text(service),
                      trailing: _isEditing
                          ? IconButton(
                              icon: const Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  List<String> updatedServices = List.from(currentDoctor.services);
                                  updatedServices.remove(service);
                                  doctorDataManager.updateDoctor(services: updatedServices);
                                });
                              },
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
              if (_isEditing)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        List<String> updatedServices = List.from(currentDoctor.services);
                        updatedServices.add("New Service"); // Placeholder for adding
                        doctorDataManager.updateDoctor(services: updatedServices);
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Service"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Back"),
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary, side: BorderSide(color: Theme.of(context).colorScheme.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.home),
                      label: const Text("Go Home"),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => UserSelectionPage()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- APP THEME (Apply this in your main.dart or a theme provider) ---
ThemeData buildAppTheme() {
  final primaryColor = Colors.blue.shade700;
  final secondaryColor = Colors.teal.shade400; // A vibrant accent color

  return ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.grey.shade900,
      background: Colors.grey.shade50,
      onBackground: Colors.grey.shade900,
      error: Colors.red.shade700,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.grey.shade50, // Light background for the overall app
    appBarTheme: AppBarTheme(
      color: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey.shade900),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.grey.shade900),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey.shade900),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.grey.shade700),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      labelLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor, side: BorderSide(color: primaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: secondaryColor,
      selectionColor: secondaryColor.withOpacity(0.3),
      selectionHandleColor: secondaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: Colors.grey.shade600),
      hintStyle: TextStyle(color: Colors.grey.shade400),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none, // Default to no border, rely on fillColor
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade700, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade700, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
  );
}
