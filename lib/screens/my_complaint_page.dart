import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyComplaintsPage extends StatelessWidget {
  const MyComplaintsPage({super.key});

  Color statusColor(String status) {
    switch (status) {
      case "Resolved":
        return Colors.green;
      case "Denied":
        return Colors.red;
      case "In Progress":
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("My Complaints")),

      //////////////////////////////////////////////////////
      /// 🔥 REALTIME STREAM (NO LOADING BUG)
      //////////////////////////////////////////////////////
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("complaints")
            .where("uid", isEqualTo: uid) // only student's complaints
            .orderBy("createdAt", descending: true)
            .snapshots(),

        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return const Center(child: Text("No complaints yet"));
          }

          final docs = snap.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i].data();

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(d["title"] ?? ""),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d["description"] ?? ""),
                      const SizedBox(height: 6),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor(d["status"]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          d["status"],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
