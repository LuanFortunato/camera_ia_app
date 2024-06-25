import 'package:camera_ia_app/model/count.dart';
import 'package:camera_ia_app/service/count_service.dart';
import 'package:camera_ia_app/view/home/products_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../products/logout_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<Count> sortCounts(List<Count> counts) {
    List<Count> sortedCounts = [];
    List<String> products = [];
    
    for (var count in counts) {
      for (var prod in products) {
        
      }
      if (count.product.name.toLowerCase())
    }
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
        body: StreamBuilder<QuerySnapshot>(
          stream: CountService().getCountsStream(),
          builder: (context, snapshot) {
            List counts = snapshot.data!.docs;

            return const Padding(
              padding: EdgeInsets.all(32),
              child: AspectRatio(
                aspectRatio: 0.6,
                child: ProductsChart(),
              ),
            );
          },
        ));
  }
}
