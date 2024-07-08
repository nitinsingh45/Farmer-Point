import 'package:farmerpoint/firebase_options.dart';
import 'package:farmerpoint/guide.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'phone.dart';
import 'verify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyPhone(),
      routes: {
        'MyVerify': (context) => const MyVerify(),
        'phone': (context) => const MyPhone(),
        'Guide': (context) => Guide(),
      },
    );
  }
}
