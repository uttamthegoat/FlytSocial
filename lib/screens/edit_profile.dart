import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Edit profile'),
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: Text('Edit profile'),
        ),
      ),
    );
  }
}