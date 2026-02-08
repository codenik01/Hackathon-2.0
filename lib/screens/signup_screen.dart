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
  final name = TextEditingController();
  final gmail = TextEditingController();
  final urn = TextEditingController();
  final pass = TextEditingController();

  String error = '';

  Future<void> signup() async {
    try {
      String email = widget.role == UserRole.student
          ? makeStudentEmail(urn.text.trim())
          : gmail.text.trim();

      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass.text);

      await firestore.collection("users").doc(cred.user!.uid).set({
        "name": name.text,
        "gmail": gmail.text,
        "role": widget.role.name,
        "urn": widget.role == UserRole.student ? urn.text : null,
      });

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message ?? "Signup failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isStudent = widget.role == UserRole.student;

    return Scaffold(
      appBar: AppBar(title: const Text("Signup")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: gmail, decoration: const InputDecoration(labelText: "Gmail")),
            if (isStudent)
              TextField(controller: urn, decoration: const InputDecoration(labelText: "URN")),
            TextField(controller: pass, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 20),
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red)),
            ElevatedButton(onPressed: signup, child: const Text("Signup"))
          ],
        ),
      ),
    );
  }
}