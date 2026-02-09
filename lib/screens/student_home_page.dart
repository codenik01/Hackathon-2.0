import 'package:campus_connect/screens/my_complaint_page.dart';
import 'package:campus_connect/screens/rise_complaint_page.dart';
import 'package:flutter/material.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Campus Connect")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RaiseComplaintPage()),
                );
              },
              child: const Text("Raise Complaint"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyComplaintsPage()),
                );
              },
              child: const Text("Track My Complaints"),
            ),
          ],
        ),
      ),
    );
  }
}
