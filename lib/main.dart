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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF141F59),
        fontFamily: 'Roboto',
      ),
      home: const RoleSelectPage(),
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
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF07182C), Color(0xFF024B94)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// PNG LOGO
            Image.network(
              'https://res.cloudinary.com/dhdzkhpfm/image/upload/v1770565460/ChatGPT_Image_Feb_8_2026_at_08_57_28_PM_kf5mgl.png',
              height: 400,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  height: 90,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.school, size: 80, color: Colors.white);
              },
            ),

            _roleButton(
              context,
              icon: Icons.person,
              text: "Student",
              role: UserRole.student,
            ),

            const SizedBox(height: 20),

            _roleButton(
              context,
              icon: Icons.person_outline,
              text: "Faculty",
              role: UserRole.faculty,
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required UserRole role,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: const Size(250, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AuthChoicePage(role: role)),
        );
      },
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF07182C), Color(0xFF024B94)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar replacement (to match image)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.blue,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      role == UserRole.student
                          ? "Student Portal"
                          : "Faculty Portal",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),

              const Spacer(),

              // Login Card
              _authCard(
                icon: Icons.login,
                title: "Login",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage(role: role)),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Signup Card
              _authCard(
                icon: Icons.person_add_alt_1,
                title: "Signup",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SignupPage(role: role)),
                  );
                },
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _authCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F4FA),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Icon(icon, size: 30, color: Colors.indigo),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// HOME PAGE
////////////////////////////////////////////////////////////

Widget _infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(value),
      ],
    ),
  );
}
