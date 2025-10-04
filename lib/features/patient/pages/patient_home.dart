import 'package:chronocancer_ai/core/widgets/drug_interaction_widget.dart';
import 'package:chronocancer_ai/features/doctor/pages/analytics_dashboard_page.dart';
import 'package:chronocancer_ai/features/patient/pages/appointment_booking_page.dart';
import 'package:chronocancer_ai/features/patient/pages/cancer_awareness_page.dart';
import 'package:chronocancer_ai/features/patient/pages/family_page.dart';
import 'package:chronocancer_ai/features/patient/pages/schedule_checkup_page.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:chronocancer_ai/features/patient/pages/doctor_list_page.dart';
import 'package:chronocancer_ai/features/patient/pages/profile_setup_page.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:chronocancer_ai/features/patient/pages/detailed_map_screen.dart';
// import 'package:intl/intl.dart';
// import 'package:chronocancer_ai/data/appointment_store.dart';
import 'package:chronocancer_ai/core/widgets/drug_interaction_widget.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChronoCancer App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: const ChronoCancerHomePage(),
      routes: {
        '/scheduling': (context) => const SchedulingPage(),
      },
    );
  }
}

class ChronoCancerHomePage extends StatefulWidget {
  const ChronoCancerHomePage({super.key});

  @override
  State<ChronoCancerHomePage> createState() => _ChronoCancerHomePageState();
}

class _ChronoCancerHomePageState extends State<ChronoCancerHomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const HomePageContent(),
          HealthAnalyticsScreen(),
          CommunityInsightsApp(),
          PatientDetailPage(),
          DoctorsListScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Family',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Me',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.family_restroom_outlined),
          label: 'Doctor',
        ),
      ],
    );
  }
}

// -------------------- HomePageContent StatefulWidget --------------------
class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  Position? _currentPosition;
  List<Map<String, dynamic>> _hospitals = [];
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _loadHospitals();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('⚠️ Location services disabled, using default location');
        _useDefaultLocation();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('⚠️ Location permission denied, using default location');
          _useDefaultLocation();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('⚠️ Location permission permanently denied, using default location');
        _useDefaultLocation();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      print('✅ Got location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('❌ Location error: $e');
      _useDefaultLocation();
    }
  }

  void _useDefaultLocation() {
    // Default to Mumbai center if location fails
    setState(() {
      _currentPosition = Position(
        latitude: 19.0760,
        longitude: 72.8777,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
      _isLoadingLocation = false;
    });
    print('📍 Using default Mumbai location');
  }

  void _loadHospitals() {
    _hospitals = [
      {
        'lat': 19.0760,
        'lng': 72.8777,
        'specialty': 'Cancer',
        'name': 'Cancer Specialty Hospital'
      },
      {
        'lat': 19.0896,
        'lng': 72.8656,
        'specialty': 'General',
        'name': 'General Hospital'
      },
      {
        'lat': 19.0589,
        'lng': 72.8889,
        'specialty': 'Cancer',
        'name': 'Cancer Treatment Center'
      },
      {
        'lat': 19.0650,
        'lng': 72.8950,
        'specialty': 'General',
        'name': 'City Hospital'
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          leading: const Icon(Icons.menu, color: Colors.white),
          title: const Text('ChronoCancer',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: CircleAvatar(
                backgroundImage:
                    AssetImage('assets/images/transparent_default_user.png'),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 20),
            _buildNavigationChips(context),
            const SizedBox(height: 20),
            _buildBloodPressureCheckDue(context),
            const SizedBox(height: 20),
            _buildCancerTypesSection(context),
            const SizedBox(height: 20),
            _buildHealthMonitoringSection(),
            const SizedBox(height: 20),
            _buildTopDoctorSection(context),
       const DrugInteractionWidget(),
    const SizedBox(height: 20),


            _buildAIReportAnalyzerSection(),
            const SizedBox(height: 20),
            _buildCheckUpLocationSection(context, _currentPosition, _hospitals),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hello, Sarah!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('How are you feeling today?',
            style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildNavigationChips(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, '/reminders'),
              borderRadius: BorderRadius.circular(12),
              child: _buildChip(Icons.calendar_today, 'Reminders',
                  Colors.purple[100]!, Colors.purple),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: _buildChip(Icons.medical_services_outlined, 'Apps',
                Colors.orange[100]!, Colors.orange),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: _buildChip(Icons.cloud_upload_outlined, 'Upload',
                Colors.blue[100]!, Colors.blue),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, '/scheduling'),
              borderRadius: BorderRadius.circular(12),
              child: _buildChip(Icons.calendar_month, 'Appointments',
                  Colors.pink[100]!, Colors.pink),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(IconData icon, String text, Color bgColor, Color iconColor) =>
      Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[800], fontSize: 12),
                  maxLines: 2),
            ),
          ],
        ),
      );

  Widget _buildBloodPressureCheckDue(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Blood Pressure Check Due',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800])),
                const SizedBox(height: 4),
                Text(
                    'Your last BP reading was 1 day ago. Regular checkups are recommended.',
                    style: TextStyle(fontSize: 13, color: Colors.orange[700])),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AppointmentBookingScreen())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text('Schedule Check',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancerTypesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Types of Cancer we treat!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CancerAwarenessPage())),
              child: const Text('See all', style: TextStyle(color: Colors.deepPurple)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCancerTypeCard('assets/images/transparent_brain_cancer.png'),
              _buildCancerTypeCard('assets/images/transparent_liver_cancer.png'),
              _buildCancerTypeCard('assets/images/transparent_lung_cancer.png'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCancerTypeCard(String imagePath) {
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(imagePath, fit: BoxFit.contain, height: 80, width: 100),
        ),
      ),
    );
  }

  Widget _buildHealthMonitoringSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircularPercentIndicator(
                      radius: 50.0,
                      lineWidth: 10.0,
                      percent: 0.78,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('78',
                              style:
                                  TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                          Text('%', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      progressColor: Colors.amber,
                      backgroundColor: Colors.grey,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Health Harmony',
                              style:
                                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.circle, color: Colors.amber, size: 12),
                              const SizedBox(width: 4),
                              Text('Good', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Live Health Monitoring',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMetricCard('120/80', 'Blood Pressure', Colors.blue),
                        _buildMetricCard('145', 'Blood Sugar', Colors.pink),
                        _buildMetricCard('98%', 'Oxygen', Colors.green),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Connect Smart Device',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String value, String label, Color color) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildTopDoctorSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Top Doctor',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DoctorsListScreen())),
              child: const Text('See all', style: TextStyle(color: Colors.deepPurple)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildDoctorCard('Dr. Marcus MD.', 'Cardiologist',
                  'assets/images/doctor1_transparent.png'),
              _buildDoctorCard('Dr. Maria Elena', 'Pediatrician',
                  'assets/images/doctor2_transparent.png'),
              _buildDoctorCard('Dr. Stevi Jossi', 'Generalist',
                  'assets/images/doctor3_transparent.png'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorCard(String name, String specialty, String imagePath) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 30, backgroundImage: AssetImage(imagePath)),
          const SizedBox(height: 8),
          Text(name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          Text(specialty, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildAIReportAnalyzerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('AI Report Analyzer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            padding: const EdgeInsets.all(20),
            dashPattern: const [6, 3],
            color: Colors.deepPurple.withOpacity(0.5),
            strokeWidth: 2,
            child: Column(
              children: [
                const Icon(Icons.cloud_upload_outlined, size: 50, color: Colors.deepPurple),
                const SizedBox(height: 12),
                Text('Upload Medical Report',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple[800])),
                const SizedBox(height: 4),
                Text('Drag & drop your reports here, or click to browse',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Choose File', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 8),
                Text('Supports PDF, JPG, PNG. Max. Size 50MB',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckUpLocationSection(
      BuildContext context, Position? currentPosition, List<Map<String, dynamic>> hospitals) {
    
    if (_isLoadingLocation || currentPosition == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Check-Up Location', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.deepPurple),
                  const SizedBox(height: 12),
                  Text('Loading map...', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Check-Up Location', 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(currentPosition.latitude, currentPosition.longitude),
                initialZoom: 13.0,
                minZoom: 10.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.chronocancer_ai',
                  errorTileCallback: (tile, error, stackTrace) {
                    print('Tile error: $error');
                  },
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(currentPosition.latitude, currentPosition.longitude),
                      width: 50,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.my_location, 
                          color: Colors.blue, 
                          size: 28
                        ),
                      ),
                    ),
                    ...hospitals.map((hospital) {
                      final isCancerHospital = hospital['specialty'] == 'Cancer';
                      return Marker(
                        point: LatLng(hospital['lat'], hospital['lng']),
                        width: 50,
                        height: 50,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.local_hospital,
                            color: isCancerHospital ? Colors.orange : Colors.red,
                            size: 28,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailedMapScreen(
                    currentPosition: currentPosition, 
                    hospitals: hospitals
                  ),
                ),
              );
            },
            icon: const Icon(Icons.map, color: Colors.white),
            label: const Text('View All Hospitals', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}