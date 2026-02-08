import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool firebaseReady = false;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
  } catch (e) {
    firebaseReady = false;
  }

  runApp(MyApp(firebaseReady: firebaseReady));
}

class MyApp extends StatelessWidget {
  final bool firebaseReady;

  const MyApp({super.key, required this.firebaseReady});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FirebaseStatusScreen(firebaseReady: firebaseReady),
    );
  }
}

class FirebaseStatusScreen extends StatelessWidget {
  final bool firebaseReady;

  const FirebaseStatusScreen({super.key, required this.firebaseReady});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('F Initialization Status')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              firebaseReady ? Icons.check_circle : Icons.error,
              size: 80,
              color: firebaseReady ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              firebaseReady
                  ? 'Firebase adsfasdf Successfully'
                  : ' Initialization Failed',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
