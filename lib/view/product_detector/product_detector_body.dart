import 'dart:convert';
import 'dart:io';

import 'package:camera_ia_app/model/product.dart';
import 'package:camera_ia_app/service/count_service.dart';
import 'package:camera_ia_app/service/products_service.dart';
import 'package:camera_ia_app/util/decoration_pattern.dart';
import 'package:camera_ia_app/util/default_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../service/image_service.dart';

class ProductDetectorBody extends StatefulWidget {
  const ProductDetectorBody({super.key});

  @override
  State<ProductDetectorBody> createState() => _ProductDetectorBodyState();
}

class _ProductDetectorBodyState extends State<ProductDetectorBody> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  String? prodName;
  String? productCode;
  String? prodCount;
  File? _image;
  String responseText = "";
  bool isLoading = false;
  bool isLoadingCount = false;
  TextEditingController countController = TextEditingController();

  Future<void> pickImage() async {
    const ImageSource source = ImageSource.gallery;

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
      isLoading = true;
    });

    String imageBase64 = base64.encode(await _image!.readAsBytes());

    try {
      var imageService = ImageService();
      String? newProduct = await imageService.detectProduct(imageBase64);
      setState(() {
        productCode = newProduct;
      });
      if (productCode == null) {
        return;
      }
      try {
        var productsService = ProductsService();
        var snapshot = await productsService.getProductByCode(productCode!);
        var data = snapshot.docs.first.data() as Map<String, dynamic>;
        Product product = Product.fromMap(data);
        setState(() {
          prodName = product.name;
        });
      } catch (e) {
        return;
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> countProducts() async {
    if (_image == null) {
      return;
    }
    if (prodName == null) {
      return;
    }

    setState(() {
      isLoadingCount = true;
    });

    var service = ImageService();

    String imageBase64 = base64.encode(await _image!.readAsBytes());

    var count = await service.countProducts(imageBase64, prodName!);

    setState(() {
      prodCount = count;
      isLoadingCount = false;
    });
  }

  Future<void> saveCount() async {
    if (prodName == null || prodCount == null) {
      return;
    }

    var service = CountService();
    service.addCount(
      Product(
        name: prodName!,
        code: prodCount!,
        uid: _firebaseAuth.currentUser!.uid,
      ),
      int.parse(prodCount!),
    );
    setState(() {
      cleanData();
    });
  }

  void cleanData() {
    setState(() {
      prodName = null;
      productCode = null;
      prodCount = null;
      _image = null;
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
    return SingleChildScrollView(
      child: Column(
        children: [
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
              Visibility(
                visible: prodName == null,
                child: DefaultButton(
                  onPressed: detectImage,
                  text: 'Detectar Produto',
                ),
              ),
              Visibility(
                visible: prodName != null && productCode != null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: DefaultButton(
                    text: 'Contar',
                    onPressed: countProducts,
                  ),
                ),
              ),
            ],
          ),
          if (isLoading) const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                prodName != null && productCode != null
                    ? 'Produto identificado: $prodName - $productCode'
                    : '',
              ),
            ),
          ),
          if (isLoadingCount) const CircularProgressIndicator(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(prodName != null && productCode != null && prodCount != null
                  ? "Número de produtos: $prodCount"
                  : ''),
              const SizedBox(width: 30),
              Visibility(
                visible: prodCount != null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: DefaultButton(
                    text: 'Alterar contagem',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Adicionar novo produto',
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: countController,
                                  decoration: DecorationPattern.inputDecoration
                                      .copyWith(labelText: 'Quantidade'),
                                ),
                                const SizedBox(height: 12),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      prodCount = countController.text;
                                    });
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                  ),
                                  child: const Text('Confirmar'),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultButton(
                  onPressed: cleanData,
                  text: 'Limpar',
                ),
                Visibility(
                  visible: prodCount != null,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: DefaultButton(
                      onPressed: () {
                        saveCount();
                        showSaveDialog(context);
                      },
                      text: 'Salvar',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
