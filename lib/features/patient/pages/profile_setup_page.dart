import 'package:flutter/material.dart';
import 'package:chronocancer_ai/features/auth/pages/login_page.dart'; // ✅ Import your real login page

class PatientDetailPage extends StatefulWidget {
  const PatientDetailPage({super.key});

  @override
  State<PatientDetailPage> createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  String _patientName = 'John Doe';
  String _patientEmail = 'john.doe@example.com';
  String _patientPhone = '+1 (555) 123-4567';
  String _patientAddress = '123 Health Lane, Wellness City';

  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_patientName),
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: const NetworkImage(
                          'https://cdn.pixabay.com/photo/2016/11/18/23/38/man-1837130_1280.jpg'),
                      backgroundColor: Colors.teal[100],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _patientName,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[800],
                          ),
                    ),
                    Text(
                      'Patient ID: 12345',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildSectionTitle(context, 'Personal Information'),
              _buildProfileInfoRow(
                  context, Icons.email, _patientEmail, 'Email'),
              _buildProfileInfoRow(
                  context, Icons.phone, _patientPhone, 'Phone'),
              _buildProfileInfoRow(
                  context, Icons.location_on, _patientAddress, 'Address'),
              const SizedBox(height: 20),

              // ✅ Edit Profile Button
              ElevatedButton.icon(
                onPressed: () async {
                  final updatedInfo = await Navigator.push<Map<String, String>>(
                    context,
                    MaterialPageRoute(
                        builder: (_) => EditProfilePage(
                              name: _patientName,
                              email: _patientEmail,
                              phone: _patientPhone,
                              address: _patientAddress,
                            )),
                  );
                  if (updatedInfo != null) {
                    setState(() {
                      _patientName = updatedInfo['name']!;
                      _patientEmail = updatedInfo['email']!;
                      _patientPhone = updatedInfo['phone']!;
                      _patientAddress = updatedInfo['address']!;
                    });
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),

              const SizedBox(height: 30),
              _buildSectionTitle(context, 'App Settings'),
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.teal),
                title: const Text('Enable Notifications'),
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _notificationsEnabled = value;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Notifications ${value ? 'enabled' : 'disabled'}')),
                      );
                    });
                  },
                  activeColor: Colors.teal,
                ),
                onTap: () {
                  setState(() {
                    _notificationsEnabled = !_notificationsEnabled;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Notifications ${_notificationsEnabled ? 'enabled' : 'disabled'}')),
                    );
                  });
                },
              ),
              _buildSettingOption(
                  context, Icons.security, 'Change Password', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                );
              }),
              _buildSettingOption(
                  context, Icons.info_outline, 'About Us', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutUsPage()),
                );
              }),

              // ✅ Logout Button
              _buildSettingOption(context, Icons.logout, 'Logout', () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (_) =>
                          const LoginPage(role: "patient")), // ✅ pass role
                  (route) => false,
                );
              }, textColor: Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
      ),
    );
  }

  Widget _buildProfileInfoRow(
      BuildContext context, IconData icon, String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Colors.grey[900]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingOption(BuildContext context, IconData icon, String title,
      VoidCallback onTap,
      {Color? textColor}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: textColor ?? Colors.teal),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, color: textColor ?? Colors.grey[800]),
        ),
        trailing:
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}

/// ------------------------
/// Supporting Pages
/// ------------------------

class EditProfilePage extends StatefulWidget {
  final String name, email, phone, address;
  const EditProfilePage(
      {super.key,
      required this.name,
      required this.email,
      required this.phone,
      required this.address});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    addressController = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.pop(context, {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'address': addressController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Edit Profile"), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 10),
            TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 10),
            TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone')),
            const SizedBox(height: 10),
            TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text("Save Changes")),
          ],
        ),
      ),
    );
  }
}

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Change Password"), backgroundColor: Colors.teal),
      body: const Center(
          child: Text("Change Password Page (implement as needed)")),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("About Us"), backgroundColor: Colors.teal),
      body: const Center(
          child: Text("About Us Page (info about the app/company)")),
    );
  }
}
