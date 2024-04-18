import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/details.dart';
import 'image_details_widget.dart';
import '../service/image_service.dart';

class ProductDetectorPage extends StatefulWidget {
  const ProductDetectorPage({super.key});

  @override
  ProductDetectorPageState createState() => ProductDetectorPageState();
}

class ProductDetectorPageState extends State<ProductDetectorPage> {
  final ImagePicker _picker = ImagePicker();
  List<Details> imageList = [];
  File? _image;
  String responseText = "";
  bool isLoading = false;

  Future<void> pickImage() async {
    const ImageSource source = ImageSource.camera;
    // final ImageSource? source = await showDialog<ImageSource>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return SimpleDialog(
    //       title: const Text('Select Image Source'),
    //       children: <Widget>[
    //         SimpleDialogOption(
    //           onPressed: () {
    //             Navigator.pop(context, ImageSource.gallery);
    //           },
    //           child: const Text('Gallery'),
    //         ),
    //         SimpleDialogOption(
    //           onPressed: () {
    //             Navigator.pop(context, ImageSource.camera);
    //           },
    //           child: const Text('Camera'),
    //         ),
    //       ],
    //     );
    //   },
    // );

    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final image = File(pickedFile.path);

      setState(() {
        _image = image;
      });
    }
  }

  Future<void> detectImage() async {
    if (_image == null) {
      return;
    }

    setState(() {
      isLoading = true; // Start loading
    });
    String imageBase64 = base64Encode(await _image!.readAsBytes());

    try {
      var imageService = ImageService();
      var newList = await imageService.detectImage(imageBase64);
      // Update state with the list of Details
      setState(() {
        imageList = newList; // Update state with the list of Details
      });
    } finally {
      setState(() {
        isLoading = false; // Stop loading regardless of success or error
      });
    }
  }

  void processDetailsData(dynamic jsonData) {
    List<Details> imageList = [];
    for (var imageData in jsonData) {
      imageList.add(Details.fromJson(imageData));
    }
    setState(() {
      imageList = imageList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Product Detector'),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('Take Photo'),
              ),
              if (_image != null)
                SizedBox(
                  height: 200,
                  child: Image.file(_image!, fit: BoxFit.cover),
                ),
              ElevatedButton(
                onPressed: detectImage,
                child: const Text('Detect Product'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: imageList.length,
                  itemBuilder: (context, index) {
                    return ImageDetailsWidget(details: imageList[index]);
                  },
                ),
              ),
            ],
          ),
          if (isLoading)
            const Positioned.fill(
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}