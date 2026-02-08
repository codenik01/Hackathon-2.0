import 'package:campus_connect/main.dart';
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
      String email = widget.role == UserRole.student
          ? makeStudentEmail(idController.text.trim())
          : idController.text.trim();

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: passController.text.trim(),
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message ?? "Login failed");
    }
  }

  Future<void> forgotPassword() async {
    String email = widget.role == UserRole.student
        ? makeStudentEmail(idController.text.trim())
        : idController.text.trim();

    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    setState(() => error = "Reset link sent to Gmail");
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.role == UserRole.student ? "URN" : "Gmail";

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: label),
            ),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red)),
            ElevatedButton(onPressed: login, child: const Text("Login")),
            TextButton(
                onPressed: forgotPassword,
                child: const Text("Forgot Password?"))
          ],
        ),
      ),
    );
  }
}