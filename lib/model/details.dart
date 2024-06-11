// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:camera_ia_app/model/product.dart';

class Count {
  final Product product;
  final String quantity;

  Count({
    required this.product,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory Count.fromMap(Map<String, dynamic> map) {
    return Count(
      product: Product.fromMap(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Count.fromJson(String source) =>
      Count.fromMap(json.decode(source) as Map<String, dynamic>);
}
