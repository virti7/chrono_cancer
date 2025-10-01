import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asha Worker App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const AshaWorkerReportsScreen(),
    );
  }
}

class AshaWorkerReportsScreen extends StatefulWidget {
  const AshaWorkerReportsScreen({super.key});

  @override
  State<AshaWorkerReportsScreen> createState() => _AshaWorkerReportsScreenState();
}

class _AshaWorkerReportsScreenState extends State<AshaWorkerReportsScreen> {
  int _selectedIndex = 0; // For the bottom navigation bar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Asha worker - Reports',
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // No shadow for the app bar
      ),
      body: SingleChildScrollView( // Use SingleChildScrollView if content might overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Asha Worker Dashboard Card
              Card(
                elevation: 0, // No shadow for this card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100, // Light green background
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Icon(Icons.favorite, color: Colors.green),
                          ),
                          const SizedBox(width: 15),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Asha Worker',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              Text(
                                'Dashboard',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.menu, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Reports & Referrals Section
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                child: SizedBox(
                  width: double.infinity, // Occupy full width
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.description, // Icon for documents/reports
                          size: 60,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Reports & Referrals',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Generate reports and manage patient referrals',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency),
            label: 'Emergency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school), // Changed to school for 'Learn'
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green, // Active tab color
        unselectedItemColor: Colors.grey, // Inactive tab color
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures all labels are visible
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade100, // Light background for the screen
    );
  }
}