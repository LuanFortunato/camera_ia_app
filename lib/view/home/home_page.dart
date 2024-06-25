import 'package:flutter/material.dart';

import '../products/logout_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: Container(),
    );
  }
}
