import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CancerAwarenessPage extends StatefulWidget {
  const CancerAwarenessPage({Key? key}) : super(key: key);

  @override
  State<CancerAwarenessPage> createState() => _CancerAwarenessPageState();
}

// ------------------- CancerType Model & Dummy Data -------------------
class CancerType {
  final String name;
  final IconData icon;
  final String description;

  CancerType({
    required this.name,
    required this.icon,
    required this.description,
  });
}

List<CancerType> dummyCancerTypes = [
  CancerType(
    name: 'Brain Cancer',
    icon: FontAwesomeIcons.brain,
    description:
        'Brain cancer is a disease in which abnormal cells form in the brain. It can be primary or metastatic. Symptoms may include headaches, seizures, and vision changes.',
  ),
  CancerType(
    name: 'Liver Cancer',
    icon: FontAwesomeIcons.laptopMedical,
    description:
        'Liver cancer begins in the liver. Risk factors include hepatitis, alcohol use, and certain genetic conditions.',
  ),
  CancerType(
    name: 'Colon Cancer',
    icon: FontAwesomeIcons.bandAid,
    description:
        'Colon cancer affects the large intestine. Symptoms may include changes in bowel habits, bleeding, and abdominal discomfort.',
  ),
  CancerType(
    name: 'Lung Cancer',
    icon: FontAwesomeIcons.lungs,
    description:
        'Lung cancer starts in the lungs. Main types are small cell and non-small cell. Smoking is the leading risk factor.',
  ),
  CancerType(
    name: 'Breast Cancer',
    icon: FontAwesomeIcons.ribbon,
    description:
        'Breast cancer forms in breast cells. Symptoms include lumps, size changes, or nipple discharge. Early detection is crucial.',
  ),
  CancerType(
    name: 'Prostate Cancer',
    icon: FontAwesomeIcons.mars,
    description:
        'Prostate cancer occurs in the prostate gland. It is common in men and often grows slowly, initially causing no symptoms.',
  ),
  CancerType(
    name: 'Skin Cancer',
    icon: FontAwesomeIcons.sun,
    description:
        'Skin cancer is the abnormal growth of skin cells, often caused by UV exposure. Common types include melanoma, basal cell, and squamous cell carcinoma.',
  ),
  CancerType(
    name: 'Pancreatic Cancer',
    icon: FontAwesomeIcons.pills,
    description:
        'Pancreatic cancer begins in the pancreas. It is often diagnosed late and may cause abdominal pain, jaundice, and weight loss.',
  ),
  CancerType(
    name: 'Kidney Cancer',
    icon: FontAwesomeIcons.handHoldingWater,
    description:
        'Kidney cancer starts in the kidneys. Symptoms may include blood in urine, lower back pain, and fatigue.',
  ),
  CancerType(
    name: 'Ovarian Cancer',
    icon: FontAwesomeIcons.venus,
    description:
        'Ovarian cancer begins in the ovaries. Symptoms include abdominal bloating, pelvic pain, and changes in bowel habits.',
  ),
  CancerType(
    name: 'Esophageal Cancer',
    icon: FontAwesomeIcons.utensils,
    description:
        'Esophageal cancer affects the esophagus. Symptoms include difficulty swallowing, chest pain, and unintentional weight loss.',
  ),
  CancerType(
    name: 'Bladder Cancer',
    icon: FontAwesomeIcons.tint,
    description:
        'Bladder cancer develops in the bladder lining. Common symptoms include blood in urine and frequent urination.',
  ),
  CancerType(
    name: 'Thyroid Cancer',
    icon: FontAwesomeIcons.userMd,
    description:
        'Thyroid cancer occurs in the thyroid gland. Symptoms include a lump in the neck, voice changes, and difficulty swallowing.',
  ),
  CancerType(
    name: 'Leukemia',
    icon: FontAwesomeIcons.droplet,
    description:
        'Leukemia is cancer of the blood-forming tissues. Symptoms include fatigue, frequent infections, and easy bruising or bleeding.',
  ),
  CancerType(
    name: 'Lymphoma',
    icon: FontAwesomeIcons.handHoldingMedical,
    description:
        'Lymphoma affects the lymphatic system. Symptoms include swollen lymph nodes, fever, and unexplained weight loss.',
  ),
  CancerType(
    name: 'Stomach Cancer',
    icon: FontAwesomeIcons.bandAid,
    description:
        'Stomach cancer begins in the stomach lining. Symptoms include abdominal pain, nausea, and difficulty swallowing.',
  ),
];

// ------------------- UI -------------------
class _CancerAwarenessPageState extends State<CancerAwarenessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Types of Cancer We Treat',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Explore different cancer types:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.2,
                ),
                itemCount: dummyCancerTypes.length,
                itemBuilder: (context, index) {
                  final cancer = dummyCancerTypes[index];
                  return _buildCancerTypeCard(context, cancer);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancerTypeCard(BuildContext context, CancerType cancer) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(cancer.name),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  FaIcon(cancer.icon, size: 50, color: Colors.blue.shade700),
                  const SizedBox(height: 20),
                  Text(cancer.description),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: FaIcon(
                cancer.icon,
                color: Colors.blue.shade700,
                size: 30,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              cancer.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
