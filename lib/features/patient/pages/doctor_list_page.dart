import 'package:flutter/material.dart';
// --- Placeholder Doctor Model ---
class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String imageUrl; // Placeholder for profile picture
  final double rating;
  final String bio;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.imageUrl,
    this.rating = 0.0,
    this.bio = 'No bio available.',
  });
}

// --- Placeholder Doctor Details Page ---
// In a real app, this would be a separate file and much more detailed.
class DoctorDetailsPage extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsPage({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
        backgroundColor: const Color(0xFF4C7DFF), // Inspired by reference image
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(doctor.imageUrl),
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              doctor.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              doctor.specialization,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text('${doctor.rating}'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              doctor.bio,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

// --- DoctorsListScreen Widget ---
class DoctorsListScreen extends StatefulWidget {
  const DoctorsListScreen({Key? key}) : super(key: key);

  @override
  State<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  final List<Doctor> _allDoctors = [
    Doctor(
        id: 'd001',
        name: 'Dr. Emily White',
        specialization: 'Cardiology',
        imageUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
        rating: 4.8,
        bio: 'Dr. White is a leading cardiologist with over 15 years of experience.'),
    Doctor(
        id: 'd002',
        name: 'Dr. John Smith',
        specialization: 'Pediatrics',
        imageUrl: 'https://randomuser.me/api/portraits/men/2.jpg',
        rating: 4.5,
        bio: 'Specializing in child healthcare, Dr. Smith is dedicated to the well-being of his young patients.'),
    Doctor(
        id: 'd003',
        name: 'Dr. Sarah Johnson',
        specialization: 'Dermatology',
        imageUrl: 'https://randomuser.me/api/portraits/women/3.jpg',
        rating: 4.9,
        bio: 'Expert in skin conditions and cosmetic dermatology.'),
    Doctor(
        id: 'd004',
        name: 'Dr. Robert Brown',
        specialization: 'Neurology',
        imageUrl: 'https://randomuser.me/api/portraits/men/4.jpg',
        rating: 4.7,
        bio: 'Focusing on disorders of the nervous system with a patient-centered approach.'),
    Doctor(
        id: 'd005',
        name: 'Dr. Olivia Davis',
        specialization: 'Oncology',
        imageUrl: 'https://randomuser.me/api/portraits/women/5.jpg',
        rating: 4.6,
        bio: 'Committed to compassionate cancer care and advanced treatment options.'),
    Doctor(
        id: 'd006',
        name: 'Dr. Michael Green',
        specialization: 'Pediatrics',
        imageUrl: 'https://randomuser.me/api/portraits/men/6.jpg',
        rating: 4.3,
        bio: 'Experienced pediatrician providing comprehensive care for infants, children, and adolescents.'),
    Doctor(
        id: 'd007',
        name: 'Dr. Anna Wilson',
        specialization: 'Cardiology',
        imageUrl: 'https://randomuser.me/api/portraits/women/7.jpg',
        rating: 4.9,
        bio: 'Dedicated to cardiovascular health and preventative medicine.'),
    Doctor(
        id: 'd008',
        name: 'Dr. David Lee',
        specialization: 'Orthopedics',
        imageUrl: 'https://randomuser.me/api/portraits/men/8.jpg',
        rating: 4.4,
        bio: 'Specialist in musculoskeletal health, sports injuries, and joint replacement.'),
  ];

  List<Doctor> _foundDoctors = [];
  String _searchQuery = '';
  String? _selectedSpecializationFilter;

  @override
  initState() {
    _foundDoctors = _allDoctors;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<Doctor> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allDoctors;
    } else {
      results = _allDoctors
          .where((doctor) =>
              doctor.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              doctor.specialization
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _searchQuery = enteredKeyword;
      _foundDoctors = results;
      _applyFilter(); // Re-apply specialization filter after search
    });
  }

  void _applyFilter() {
    List<Doctor> filteredBySearch = (_searchQuery.isEmpty)
        ? _allDoctors
        : _allDoctors
            .where((doctor) =>
                doctor.name
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                doctor.specialization
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
            .toList();

    if (_selectedSpecializationFilter == null ||
        _selectedSpecializationFilter == 'All') {
      setState(() {
        _foundDoctors = filteredBySearch;
      });
    } else {
      setState(() {
        _foundDoctors = filteredBySearch
            .where((doctor) =>
                doctor.specialization == _selectedSpecializationFilter)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract unique specializations for the filter dropdown
    Set<String> specializations =
        _allDoctors.map((d) => d.specialization).toSet();
    List<String> filterOptions = ['All', ...specializations];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Doctor'),
        backgroundColor: const Color(0xFF4C7DFF), // Inspired by reference image
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: 'Search doctors by name or specialization',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FE), // Light blue from ref image
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFC0DFFF)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSpecializationFilter ?? 'All',
                    icon: const Icon(Icons.filter_list,
                        color: Color(0xFF4C7DFF)),
                    style: const TextStyle(
                        color: Color(0xFF4C7DFF), fontSize: 16),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSpecializationFilter = newValue;
                        _applyFilter();
                      });
                    },
                    items: filterOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _foundDoctors.isEmpty
                ? Center(
                    child: Text(
                      'No doctors found for your search/filter.',
                      style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                    ),
                  )
                : ListView.builder(
                    itemCount: _foundDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = _foundDoctors[index];
                      return DoctorListItem(doctor: doctor);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// --- DoctorListItem Widget ---
class DoctorListItem extends StatelessWidget {
  final Doctor doctor;

  const DoctorListItem({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorDetailsPage(doctor: doctor),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(doctor.imageUrl),
                backgroundColor: Colors.grey.shade200,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.specialization,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${doctor.rating}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}


// --- How to use this in your main.dart or a similar file ---
/*
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DoctorsListScreen(), // Your new screen
    );
  }
}
*/