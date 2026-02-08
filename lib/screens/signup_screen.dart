import 'package:campus_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


String makeStudentEmail(String urn) => "student$urn@college.com";

class SignupPage extends StatefulWidget {
  final UserRole role;
  const SignupPage({super.key, required this.role});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final gmail = TextEditingController();
  final urn = TextEditingController();
  final pass = TextEditingController();
  final confirmPass = TextEditingController();

  String error = '';

  Future<void> signup() async {
    if (pass.text != confirmPass.text) {
      setState(() => error = "Passwords do not match");
      return;
    }

    try {
      final email = widget.role == UserRole.student
          ? makeStudentEmail(urn.text.trim())
          : gmail.text.trim();

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass.text.trim(),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message ?? "Signup failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isStudent = widget.role == UserRole.student;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B2D4F), Color(0xFF1E64B7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F1D3),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  
                  children: [
                    const Text(
                      "CREATE ACCOUNT",
                      style: TextStyle(
                        fontSize: 24,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 25),

                    _field(gmail, "University Email"),
                    if (isStudent) const SizedBox(height: 15),
                    if (isStudent) _field(urn, "URN"),
                    const SizedBox(height: 15),
                    _field(pass, "Create Password", obscure: true),
                    const SizedBox(height: 15),
                    _field(confirmPass, "Re-enter Password", obscure: true),

                    if (error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          error,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    const SizedBox(height: 25),


                  SafeArea(
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        onPressed: () => Navigator.pop(context),
      ),),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      
    );
  }

  Widget _field(
    TextEditingController controller,
    String hint, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
