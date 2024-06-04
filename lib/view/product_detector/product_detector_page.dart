import 'dart:convert';
import 'dart:io';

import 'package:camera_ia_app/model/product.dart';
import 'package:camera_ia_app/service/products_service.dart';
import 'package:camera_ia_app/view/product_detector/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/details.dart';
import 'image_details_widget.dart';
import '../../service/image_service.dart';

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

    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final image = File(pickedFile.path);

      setState(() {
        _image = image;
      });
    }
  }

  void saveProducts() {
    List<Product> products = [];
    for (var product in imageList) {
      products.add(
        Product(
          name: product.name,
          quantity: int.parse(product.quantity),
        ),
      );
    }
    var service = ProductsService();
    service.addProducts(products);
  }

  void cleanData() {
    setState(() {
      imageList = [];
    });
  }

  Future<void> detectImage() async {
    if (_image == null) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    String imageBase64 = base64.encode(await _image!.readAsBytes());

    try {
      var imageService = ImageService();
      var newList = await imageService.detectImage(imageBase64);
      setState(() {
        imageList = newList;
      });
    } finally {
      setState(() {
        isLoading = false;
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

  showSaveDialog(context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Salvo com sucesso!'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Row(
                children: [
                  Spacer(),
                  Text(
                    'Confirmar',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(223, 228, 224, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(223, 228, 224, 1),
        centerTitle: true,
        title: const Text('Detectar produto'),
      ),
      body: Column(
        children: [
          const Row(
            children: [
              Spacer(),
              LogoutButton(),
              SizedBox(width: 20),
            ],
          ),
          _image != null
              ? Padding(
                  padding: const EdgeInsets.all(32),
                  child: SizedBox(
                    height: 200,
                    child: Image.file(_image!, fit: BoxFit.cover),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.all(32),
                  height: 250,
                  width: 170,
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: pickImage,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(249, 134, 98, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                ),
                child: const Text('Tirar foto'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: detectImage,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(249, 134, 98, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                ),
                child: const Text('Detectar Produtos'),
              ),
            ],
          ),
          if (isLoading) const CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: imageList.length,
              itemBuilder: (context, index) {
                return ImageDetailsWidget(details: imageList[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: cleanData,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(249, 134, 98, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  ),
                  child: const Text('Limpar'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    saveProducts();
                    showSaveDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(249, 134, 98, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  ),
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
