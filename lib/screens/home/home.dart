import 'package:flutter/material.dart';

import './components/main_shelf.dart';

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Image.asset('assets/icons/logo_topolino.png'),
            ),
            const Text("Collezione Topolino"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: const Center(
        child: MainShelf(),
      ),
    );
  }
}
