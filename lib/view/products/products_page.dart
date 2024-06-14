import 'package:camera_ia_app/service/products_service.dart';
import 'package:camera_ia_app/view/products/logout_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/product.dart';
import 'add_product_dialog.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ProductsService productsService = ProductsService();

  void addProduct() {
    showDialog(
      context: context,
      builder: (context) {
        return AddProductDialog(
          productsService: productsService,
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: LogoutButton(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: const Color.fromRGBO(223, 228, 224, 1),
        onPressed: () {
          addProduct();
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productsService.getProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List products = snapshot.data!.docs;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = products[index];

                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                Product product = Product.fromMap(data);

                return ListTile(
                  leading: Text(product.name),
                  trailing: Text(product.code),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Nenhum produto encontrado ...'),
            );
          }
        },
      ),
    );
  }
}
