import 'dart:convert';

class Details {
  final String name;
  final String quantity;

  Details({
    required this.name,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'quantity': quantity,
    };
  }

  factory Details.fromMap(Map<String, dynamic> map) {
    return Details(
      name: map['name'] as String,
      quantity: map['quantity'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Details.fromJson(String source) =>
      Details.fromMap(json.decode(source) as Map<String, dynamic>);
}
