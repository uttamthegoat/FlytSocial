import 'package:flutter/material.dart';

class AppSearch extends StatelessWidget {
  const AppSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      backgroundColor: Colors.orange,
      body: Container(
        child: const Center(
          child: Text('AppSearch'),
        ),
      ),
    );
  }
}
