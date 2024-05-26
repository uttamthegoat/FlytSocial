import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  const PostItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.green,
      body: Container(
        child: const Center(
          child: Text('PostItem'),
        ),
      ),
    );
  }
}
