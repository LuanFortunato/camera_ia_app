import 'package:camera_ia_app/service/products_service.dart';
import 'package:camera_ia_app/util/decoration_pattern.dart';
import 'package:flutter/material.dart';

class AddProductDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  final ProductsService productsService;

  AddProductDialog({super.key, required this.productsService});

  void clearControllers() {
    nameController.clear();
    codeController.clear();
  }

  @override
  Widget build(BuildContext context) {
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
            controller: nameController,
            decoration:
                DecorationPattern.inputDecoration.copyWith(labelText: 'Nome'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: codeController,
            decoration: DecorationPattern.inputDecoration
                .copyWith(labelText: 'Código de identificação'),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  clearControllers();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                ),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  productsService.addProduct(
                    nameController.text,
                    codeController.text,
                  );
                  clearControllers();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(249, 134, 98, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                ),
                child: const Text('Adicionar'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
