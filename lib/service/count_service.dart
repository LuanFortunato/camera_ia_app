import 'package:camera_ia_app/model/count.dart';
import 'package:camera_ia_app/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CountService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final CollectionReference counts =
      FirebaseFirestore.instance.collection('counts');

  void addCount(Product product, int qtd) {
    counts.add(
      Count(
        product: product,
        quantity: qtd,
        dateTime: DateTime.now(),
        uid: _firebaseAuth.currentUser!.uid,
      ).toMap(),
    );
  }

  Stream<QuerySnapshot> getCountsStream() {
    Stream<QuerySnapshot> countsStream = counts
        .where('uid', isEqualTo: _firebaseAuth.currentUser!.uid)
        .snapshots();

    return countsStream;
  }
}
