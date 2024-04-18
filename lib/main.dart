import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'view/product_detector_page.dart';

Future main() async {
  debugPrint("Loading .env file");
  try {
    await dotenv.load(fileName: ".env");
    debugPrint("Successfully loaded .env file");
  } catch (e) {
    debugPrint("Failed to load .env file: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Product Detector',
      home: ProductDetectorPage(),
    );
  }
}
