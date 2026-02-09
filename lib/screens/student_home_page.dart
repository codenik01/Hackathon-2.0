import 'package:campus_connect/screens/my_complaint_page.dart';
import 'package:campus_connect/screens/rise_complaint_page.dart';
import 'package:flutter/material.dart';


class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  //////////////////////////////////////////////////////////
  /// DASHBOARD CARD
  //////////////////////////////////////////////////////////
  Widget dashCard(
      BuildContext context, IconData icon, String title, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 90,
          child: Row(
            children: [
              Icon(icon, size: 35, color: Colors.blue),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////
  /// UI
  //////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Student Dashboard"),
        backgroundColor: const Color(0xFF141F59),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ////////////////////////////////////////////////////
            /// HEADER
            ////////////////////////////////////////////////////
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF141F59),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Campus Connect",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Raise issues • Track status • Get help",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ////////////////////////////////////////////////////
            /// OPTIONS
            ////////////////////////////////////////////////////
            dashCard(
              context,
              Icons.add_circle_outline,
              "Raise Complaint",
              const RaiseComplaintPage(),
            ),

            dashCard(
              context,
              Icons.track_changes,
              "Track My Complaints",
              const MyComplaintsPage(),
            ),

            dashCard(
              context,
              Icons.school,
              "Campus Resources",
              const ResourcesPage(),
            ),

            dashCard(
              context,
              Icons.warning_amber_rounded,
              "Emergency Help",
              const EmergencyPage(),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// RESOURCES PAGE
////////////////////////////////////////////////////////////
class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campus Resources"),
        backgroundColor: const Color(0xFF141F59),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.people),
            title: Text("Staff Directory"),
            subtitle: Text("Find faculty & staff contacts"),
          ),
          ListTile(
            leading: Icon(Icons.build),
            title: Text("Maintenance Office"),
            subtitle: Text("Maintenance related help"),
          ),
          ListTile(
            leading: Icon(Icons.policy),
            title: Text("Policy Documents"),
            subtitle: Text("University rules & guidelines"),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// EMERGENCY PAGE
////////////////////////////////////////////////////////////
class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Help"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.local_police, color: Colors.red),
            title: Text("Campus Security"),
            subtitle: Text("📞 100"),
          ),
          ListTile(
            leading: Icon(Icons.local_hospital, color: Colors.red),
            title: Text("Medical Help"),
            subtitle: Text("📞 102"),
          ),
          ListTile(
            leading: Icon(Icons.fire_truck, color: Colors.red),
            title: Text("Fire Emergency"),
            subtitle: Text("📞 101"),
          ),
        ],
      ),
    );
  }
}