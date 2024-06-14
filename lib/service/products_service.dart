// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:camera_ia_app/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductsService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  void addProduct(String name, String code) {
    products.add(
      Product(
        name: name,
        code: code,
        uid: _firebaseAuth.currentUser!.uid,
      ).toMap(),
    );
  }

  Stream<QuerySnapshot> getProductsStream() {
    final productsStream = products
        .where('uid', isEqualTo: _firebaseAuth.currentUser!.uid)
        .snapshots();

    return productsStream;
  }

  // void addProducts(List<Product> products) {
  //   for (var product in products) {
  //     _firebaseFirestore.collection('products').add(product.toMap());
  //   }
  // }
}
