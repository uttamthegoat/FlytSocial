import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('username1'),
      ),
      body: const Center(
        child: Text('Name1'),
      ),
    );
  }
}
