import 'package:camera_ia_app/model/count.dart';
import 'package:camera_ia_app/model/product.dart';
import 'package:camera_ia_app/service/count_service.dart';
import 'package:camera_ia_app/view/home/products_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../products/logout_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<Count> sortCounts(List<Count> counts) {
    List<Count> sortedCounts = [];
    List<Product> products = [];

    for (var count in counts) {
      bool exist = false;
      for (var prod in products) {
        if (prod.name == count.product.name) {
          exist = true;
        }
      }
      if (!exist) {
        products.add(
          count.product,
        );
      }
    }

    for (var prod in products) {
      int quantity = 0;
      for (var element in counts) {
        if (element.product.name == prod.name) {
          quantity += element.quantity;
        }
      }

      sortedCounts.add(
        Count(
            product: prod,
            quantity: quantity,
            dateTime: DateTime.now(),
            uid: ""),
      );
      sortedCounts.sort(
        (a, b) => a.quantity.compareTo(b.quantity),
      );
    }

    return sortedCounts.reversed.toList();
  }

  List<ProductWithPercentages> calculatePercentages(List<Count> counts) {
    int totalQuantity = counts.fold(0, (som, item) => som + item.quantity);

    double cumulativePercentage = 0.0;
    return counts.map((countProd) {
      double percentageOfTotal = (countProd.quantity / totalQuantity) * 100;
      cumulativePercentage += percentageOfTotal;
      return ProductWithPercentages(
        counts.indexOf(countProd) + 1,
        countProd.quantity,
        percentageOfTotal,
        cumulativePercentage,
        countProd.product.name,
      );
    }).toList();
  }

  // List<TableRow> createTable(List<Count> counts) {
  //   int size = counts.length <= 10 ? counts.length : 10;
  //   List<TableRow> rows = [];

  //   for (var i = 0; i < size; i++) {
  //     rows.add(
  //       const Table Row(
  //         children: [
  //           Text(""),
  //         ],
  //       ),
  //     );
  //   }
  // }

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
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            List<Count> counts = [];

            for (var element in snapshot.data!.docs) {
              counts.add(
                Count.fromMap(element.data() as Map<String, dynamic>),
              );
            }

            counts = sortCounts(counts);

            List<ProductWithPercentages> productWithPercentages =
                calculatePercentages(counts);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bem-Vindo',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'Relação de contagem de produtos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double columnWidth = constraints.maxWidth / 5;

                        return DataTable(
                          columnSpacing: columnWidth * 0.1,
                          columns: [
                            DataColumn(
                              label: SizedBox(
                                width: columnWidth / 2,
                                child: const Text('Rank'),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: columnWidth + columnWidth * 0.5,
                                child: const Text('Nome'),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: columnWidth / 2,
                                child: const Text('Qtd'),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: columnWidth - 16,
                                child: const Text('%'),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: columnWidth,
                                child: const Text('Total %'),
                              ),
                            ),
                          ],
                          rows: productWithPercentages.map((product) {
                            return DataRow(cells: [
                              DataCell(
                                Text(product.code.toString()),
                              ),
                              DataCell(
                                Text(product.name.toString()),
                              ),
                              DataCell(
                                Text(product.quantity.toString()),
                              ),
                              DataCell(
                                Text(
                                    '${product.percentageOfTotal.toStringAsFixed(2)}%'),
                              ),
                              DataCell(
                                Text(
                                    '${product.cumulativePercentage.toStringAsFixed(2)}%'),
                              ),
                            ]);
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 50),
                    AspectRatio(
                      aspectRatio: 0.6,
                      child: ProductsChart(counts: counts),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}

class ProductWithPercentages {
  final int code;
  final String name;
  final int quantity;
  final double percentageOfTotal;
  final double cumulativePercentage;

  ProductWithPercentages(this.code, this.quantity, this.percentageOfTotal,
      this.cumulativePercentage, this.name);
}
