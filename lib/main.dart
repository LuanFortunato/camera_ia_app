import 'package:flutter/material.dart';

import 'view/product_detector_page.dart';

Future main() async {
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
