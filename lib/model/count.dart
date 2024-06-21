// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:camera_ia_app/model/product.dart';

class Count {
  final Product product;
  final int quantity;
  final DateTime dateTime;
  final String uid;

  Count({
    required this.product,
    required this.quantity,
    required this.dateTime,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product': product.toMap(),
      'quantity': quantity,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'uid': uid,
    };
  }

  factory Count.fromMap(Map<String, dynamic> map) {
    return Count(
      product: Product.fromMap(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Count.fromJson(String source) =>
      Count.fromMap(json.decode(source) as Map<String, dynamic>);
}
