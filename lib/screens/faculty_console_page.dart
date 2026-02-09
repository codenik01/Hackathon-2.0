import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FacultyConsolePage extends StatefulWidget {
  const FacultyConsolePage({super.key});

  @override
  State<FacultyConsolePage> createState() => _FacultyConsolePageState();
}

class _FacultyConsolePageState extends State<FacultyConsolePage> {
  String filter = "All";

  ////////////////////////////////////////////////////////////
  /// STATUS COLOR
  ////////////////////////////////////////////////////////////
  Color statusColor(String status) {
    switch (status) {
      case "Submitted":
        return Colors.orange;
      case "In Progress":
        return Colors.blue;
      case "Resolved":
        return Colors.green;
      case "Denied":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  ////////////////////////////////////////////////////////////
  /// PRIORITY COLOR
  ////////////////////////////////////////////////////////////
  Color priorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  ////////////////////////////////////////////////////////////
  /// UPDATE STATUS
  ////////////////////////////////////////////////////////////
  Future<void> updateStatus(String id, String status) async {
    await FirebaseFirestore.instance.collection("complaints").doc(id).update({
      "status": status,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  ////////////////////////////////////////////////////////////
  /// FILTER LOGIC
  ////////////////////////////////////////////////////////////
  bool applyFilter(Map<String, dynamic> d) {
    if (filter == "High Priority") return d["priority"] == "High";
    if (filter == "In Progress") return d["status"] == "In Progress";
    return true;
  }

  ////////////////////////////////////////////////////////////
  /// FILTER BUTTON
  ////////////////////////////////////////////////////////////
  Widget filterBtn(String text) {
    final selected = filter == text;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(text),
        selected: selected,
        onSelected: (_) => setState(() => filter = text),
        selectedColor: Colors.blue,
        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// UI
  ////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      ////////////////////////////////////////////////////////////
      /// APP BAR (DARK BLUE LIKE IMAGE)
      ////////////////////////////////////////////////////////////
      appBar: AppBar(
        title: const Text("Review Queue"),
        backgroundColor: const Color(0xFF141F59),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      ////////////////////////////////////////////////////////////
      /// BODY
      ////////////////////////////////////////////////////////////
      body: Column(
        children: [
          ////////////////////////////////////////////////////////
          /// FILTER TABS
          ////////////////////////////////////////////////////////
          Container(
            padding: const EdgeInsets.all(12),
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                filterBtn("All"),
                filterBtn("High Priority"),
                filterBtn("In Progress"),
              ],
            ),
          ),

          ////////////////////////////////////////////////////////
          /// COMPLAINT LIST
          ////////////////////////////////////////////////////////
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("complaints")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snap.data!.docs
                    .where((e) => applyFilter(e.data()))
                    .toList();

                if (docs.isEmpty) {
                  return const Center(child: Text("No complaints found"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final d = docs[i].data();
                    final id = docs[i].id;

                    //////////////////////////////////////////////////////
                    /// COMPLAINT CARD (LIKE IMAGE)
                    //////////////////////////////////////////////////////
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //////////////////////////////////////////////////
                            /// TITLE ROW
                            //////////////////////////////////////////////////
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${d["category"]} from ${d["name"]}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),

                                /// STATUS BADGE
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

                            const SizedBox(height: 8),

                            //////////////////////////////////////////////////
                            /// DESCRIPTION
                            //////////////////////////////////////////////////
                            Text(d["description"] ?? ""),

                            const SizedBox(height: 6),

                            //////////////////////////////////////////////////
                            /// PRIORITY
                            //////////////////////////////////////////////////
                            Text(
                              "Priority: ${d["priority"]}",
                              style: TextStyle(
                                color: priorityColor(d["priority"]),
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 8),

                            //////////////////////////////////////////////////
                            /// ACTION MENU
                            //////////////////////////////////////////////////
                            Align(
                              alignment: Alignment.centerRight,
                              child: PopupMenuButton<String>(
                                onSelected: (v) => updateStatus(id, v),
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                    value: "In Progress",
                                    child: Text("In Progress"),
                                  ),
                                  PopupMenuItem(
                                    value: "Resolved",
                                    child: Text("Resolved"),
                                  ),
                                  PopupMenuItem(
                                    value: "Denied",
                                    child: Text("Denied"),
                                  ),
                                ],
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
          ),

          ////////////////////////////////////////////////////////
          /// CAMPUS RESOURCES (BOTTOM SECTION LIKE IMAGE)
          ////////////////////////////////////////////////////////
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Campus Resources",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),

                resourceTile(Icons.people, "Staff Directory"),
                resourceTile(Icons.build, "Maintenance Requests"),
                resourceTile(Icons.policy, "Policy Documents"),
                resourceTile(Icons.warning, "Emergency Procedures"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// RESOURCE TILE
  ////////////////////////////////////////////////////////////
  Widget resourceTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: () {},
    );
  }
}
