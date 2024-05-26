import 'package:flutter/material.dart';

class NewPost extends StatelessWidget {
  const NewPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
      ),
      backgroundColor: Colors.amber,
      body: Container(
        child: const Center(
          child: Text('NewPost'),
        ),
      ),
    );
  }
}
