import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RaiseComplaintPage extends StatefulWidget {
  const RaiseComplaintPage({super.key});

  @override
  State<RaiseComplaintPage> createState() => _RaiseComplaintPageState();
}

class _RaiseComplaintPageState extends State<RaiseComplaintPage> {
  final _formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final building = TextEditingController();
  final room = TextEditingController();
  final description = TextEditingController();

  String category = "Electrical";
  String priority = "Medium";

  bool loading = false;
  String error = '';

  final firestore = FirebaseFirestore.instance;

  //////////////////////////////////////////////////////
  /// 🔥 SUBMIT COMPLAINT (FULL BACKEND LOGIC)
  //////////////////////////////////////////////////////
  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        loading = true;
        error = '';
      });

      final user = FirebaseAuth.instance.currentUser!;
      final uid = user.uid;

      /// 🔥 get user data (name + role)
      final userDoc = await firestore.collection("users").doc(uid).get();

      final userData = userDoc.data() ?? {};

      /// 🔥 create complaint document
      await firestore.collection("complaints").add({
        /// USER INFO
        "uid": uid,
        "name": userData["name"] ?? "",
        "gmail": userData["gmail"] ?? "",
        "role": userData["role"] ?? "student",

        /// COMPLAINT INFO
        "title": title.text.trim(),
        "building": building.text.trim(),
        "room": room.text.trim(),
        "description": description.text.trim(),
        "category": category,
        "priority": priority,

        /// STATUS
        "status": "Submitted", // Submitted | In Progress | Resolved | Denied
        /// TIMESTAMPS
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });

      /// clear fields
      title.clear();
      building.clear();
      room.clear();
      description.clear();

      /// success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complaint submitted successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() => loading = false);
    }
  }

  //////////////////////////////////////////////////////
  /// UI
  //////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Raise Complaint"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ////////////////// TITLE
              TextFormField(
                controller: title,
                validator: (v) => v!.isEmpty ? "Enter complaint title" : null,
                decoration: const InputDecoration(labelText: "Title"),
              ),

              ////////////////// BUILDING
              TextFormField(
                controller: building,
                validator: (v) => v!.isEmpty ? "Enter building/wing" : null,
                decoration: const InputDecoration(labelText: "Building/Wing"),
              ),

              ////////////////// ROOM
              TextFormField(
                controller: room,
                validator: (v) => v!.isEmpty ? "Enter room number" : null,
                decoration: const InputDecoration(labelText: "Room No"),
              ),

              const SizedBox(height: 12),

              ////////////////// CATEGORY
              DropdownButtonFormField(
                value: category,
                items: const [
                  DropdownMenuItem(
                    value: "Electrical",
                    child: Text("Electrical"),
                  ),
                  DropdownMenuItem(value: "Water", child: Text("Water")),
                  DropdownMenuItem(
                    value: "Furniture",
                    child: Text("Furniture"),
                  ),
                  DropdownMenuItem(value: "Cleaning", child: Text("Cleaning")),
                  DropdownMenuItem(value: "Internet", child: Text("Internet")),
                  DropdownMenuItem(value: "Other", child: Text("Other")),
                ],
                onChanged: (v) => category = v!,
                decoration: const InputDecoration(labelText: "Category"),
              ),

              ////////////////// PRIORITY
              DropdownButtonFormField(
                value: priority,
                items: const [
                  DropdownMenuItem(value: "Low", child: Text("Low")),
                  DropdownMenuItem(value: "Medium", child: Text("Medium")),
                  DropdownMenuItem(value: "High", child: Text("High")),
                ],
                onChanged: (v) => priority = v!,
                decoration: const InputDecoration(labelText: "Priority"),
              ),

              ////////////////// DESCRIPTION
              TextFormField(
                controller: description,
                maxLines: 4,
                validator: (v) => v!.isEmpty ? "Enter description" : null,
                decoration: const InputDecoration(labelText: "Description"),
              ),

              const SizedBox(height: 20),

              ////////////////// ERROR
              if (error.isNotEmpty)
                Text(error, style: const TextStyle(color: Colors.red)),

              ////////////////// SUBMIT BUTTON
              ElevatedButton(
                onPressed: loading ? null : submit,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Submit Complaint"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
