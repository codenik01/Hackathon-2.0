import 'package:campus_connect/screens/login_screen.dart';
import 'package:campus_connect/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

  

////////////////////////////////////////////////////////////
/// MAIN
////////////////////////////////////////////////////////////

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

////////////////////////////////////////////////////////////
/// GLOBAL FIRESTORE
////////////////////////////////////////////////////////////

final firestore = FirebaseFirestore.instance;

////////////////////////////////////////////////////////////
/// ENUM
////////////////////////////////////////////////////////////

enum UserRole { student, faculty }

////////////////////////////////////////////////////////////
/// APP
////////////////////////////////////////////////////////////

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RoleSelectPage(),
    );
  }
}

////////////////////////////////////////////////////////////
/// ROLE SELECT
////////////////////////////////////////////////////////////

class RoleSelectPage extends StatelessWidget {
  const RoleSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signup/Login as")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Student"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AuthChoicePage(role: UserRole.student),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Faculty"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AuthChoicePage(role: UserRole.faculty),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// LOGIN / SIGNUP CHOICE
////////////////////////////////////////////////////////////

class AuthChoicePage extends StatelessWidget {
  final UserRole role;
  const AuthChoicePage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Option")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Login"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginPage(role: role),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Signup"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SignupPage(role: role),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// HOME PAGE
////////////////////////////////////////////////////////////

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: firestore.collection("users").doc(user!.uid).get(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snap.data!.data()!;

        return Scaffold(
          appBar: AppBar(title: const Text("Home")),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Name: ${data['name']}"),
                Text("Gmail: ${data['gmail']}"),
                Text("Role: ${data['role']}"),
                if (data['urn'] != null) Text("URN: ${data['urn']}"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RoleSelectPage()),
                      (_) => false,
                    );
                  },
                  child: const Text("Logout"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}