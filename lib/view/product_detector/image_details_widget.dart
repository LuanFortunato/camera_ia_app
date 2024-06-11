import 'package:flutter/material.dart';

class ImageDetailsWidget extends StatelessWidget {
  final String? cod;

  const ImageDetailsWidget({super.key, required this.cod});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            cod ?? "No code found",
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
