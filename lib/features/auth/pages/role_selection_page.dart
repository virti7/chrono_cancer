import 'package:flutter/material.dart';
import 'login_page.dart'; // Make sure this file is in the same folder

class UserSelectionPage extends StatefulWidget {
  const UserSelectionPage({Key? key}) : super(key: key);

  @override
  _UserSelectionPageState createState() => _UserSelectionPageState();
}

class _UserSelectionPageState extends State<UserSelectionPage> {
  String? _selectedRole; // To store the selected role

  // Define colors from your theme
  static const Color _primaryBlue = Color(0xFF4A7DFF); // A slightly darker blue for primary elements
  static const Color _lightBlue = Color(0xFFE8F0FF); // Light blue background
  static const Color _accentGreen = Color(0xFF6BFF8A); // Green for "healthy" or positive indicators
  static const Color _accentOrange = Color(0xFFFFA500); // Orange for warnings/attention needed
  static const Color _greyText = Color(0xFF7A8B9E); // For secondary text
  static const Color _cardColor = Colors.white; // For card backgrounds
  static const Color _borderColor = Color(0xFFE0E0E0); // For borders

  void _goToLogin() {
    if (_selectedRole != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(role: _selectedRole!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBlue, // Use the light blue as background
      appBar: AppBar(
        title: const Text(
          'Select Your Role',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _primaryBlue, // Primary blue for the app bar
        elevation: 0, // No shadow for a cleaner look
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Welcome! Please choose your role to proceed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              _buildRoleSelectionCard(
                context,
                role: 'Doctor',
                icon: Icons.person_pin_outlined,
                description: 'Access patient records, manage appointments, and view analytics.',
                color: _primaryBlue,
              ),
              const SizedBox(height: 20),
              _buildRoleSelectionCard(
                context,
                role: 'Patient',
                icon: Icons.personal_injury_outlined,
                description: 'Monitor your health, upload reports, and schedule consultations.',
                color: _accentGreen,
              ),
              const SizedBox(height: 20),
              _buildRoleSelectionCard(
                context,
                role: 'ASHA Worker',
                icon: Icons.people_outline,
                description: 'Support community health, manage family data, and outreach programs.',
                color: _accentOrange,
              ),
              const SizedBox(height: 40),
              if (_selectedRole != null)
                ElevatedButton(
                  onPressed: _goToLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Continue as $_selectedRole',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelectionCard(
    BuildContext context, {
    required String role,
    required IconData icon,
    required String description,
    required Color color,
  }) {
    bool isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? color : _borderColor,
            width: isSelected ? 3.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, size: 35, color: color),
            ),
            const SizedBox(height: 15),
            Text(
              role,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: _greyText,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 15),
              Icon(Icons.check_circle, color: color, size: 28),
            ],
          ],
        ),
      ),
    );
  }
}
