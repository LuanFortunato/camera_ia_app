import 'package:camera_ia_app/view/product_detector/product_detector_body.dart';
import 'package:flutter/material.dart';

class ProductDetectorPage extends StatefulWidget {
  const ProductDetectorPage({super.key});

  @override
  ProductDetectorPageState createState() => ProductDetectorPageState();
}

class ProductDetectorPageState extends State<ProductDetectorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(223, 228, 224, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(223, 228, 224, 1),
        centerTitle: true,
        title: const Text('Detectar produto'),
      ),
      body: const ProductDetectorBody(),
    );
  }
}
