import 'package:campus_connect/main.dart';
import 'package:campus_connect/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


String makeStudentEmail(String urn) => "student$urn@college.com";

class LoginPage extends StatefulWidget {
  final UserRole role;
  const LoginPage({super.key, required this.role});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final idController = TextEditingController();
  final passController = TextEditingController();
  String error = '';

  Future<void> login() async {
    try {
      final email = widget.role == UserRole.student
          ? makeStudentEmail(idController.text.trim())
          : idController.text.trim();

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: passController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message ?? "Login failed");
    }
  }

  Future<void> forgotPassword() async {
    final email = widget.role == UserRole.student
        ? makeStudentEmail(idController.text.trim())
        : idController.text.trim();

    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    setState(() => error = "Password reset link sent");
  }

  @override
  Widget build(BuildContext context) {
    final label =
        widget.role == UserRole.student ? "University Email / URN" : "University Email";

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
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Campus Connect",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
//
 
                  // LOGIN CARD
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F1D3),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "WELCOME",
                          style: TextStyle(
                            fontSize: 24,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 25),

                        _inputField(
                          controller: idController,
                          hint: label,
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 15),
                        _inputField(
                          controller: passController,
                          hint: "Password",
                          icon: Icons.lock_outline,
                          obscure: true,
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: forgotPassword,
                            child: const Text(
                              "Forgot your password?",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),

                        if (error.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              error,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),

                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Sign up",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SafeArea(
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        onPressed: () => Navigator.pop(context),
      ),),

                  const SizedBox(height: 25),
                  Text(
                    "Selected Role",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.role == UserRole.student
                          ? "Student"
                          : "Faculty",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SignupPage(role: widget.role),
                        ),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
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
