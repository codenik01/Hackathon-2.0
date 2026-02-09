import 'package:campus_connect/screens/student_home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'faculty_console_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection("users").doc(uid).get(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final role = snap.data!.data()!["role"];

        /////////////////////////////////////////////////////
        /// 🔥 ROLE BASED NAVIGATION
        /////////////////////////////////////////////////////
        if (role == "faculty") {
          /// ❌ NO RAISE COMPLAINT HERE
          return const FacultyConsolePage();
        } else {
          return const StudentHomePage();
        }
      },
    );
  }
}
