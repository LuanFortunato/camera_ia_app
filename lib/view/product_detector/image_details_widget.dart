import 'package:camera_ia_app/model/details.dart';
import 'package:flutter/material.dart';

class ImageDetailsWidget extends StatelessWidget {
  final Details details;

  const ImageDetailsWidget({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              details.name != "No items found"
                  ? "${details.quantity}x ${details.name}"
                  : details.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
