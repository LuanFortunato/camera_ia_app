// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:camera_ia_app/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsService {
  final FirebaseFirestore _firebaseFirestore;

  ProductsService({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  void addProducts(List<Product> products) {
    for (var product in products) {
      _firebaseFirestore.collection('products').add(product.toMap());
    }
  }
}
