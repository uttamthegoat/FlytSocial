import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final Map<String, String> user;

  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user['username'] ?? 'Unknown User'), // Using username as title
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Username: ${user['username']}'),
            Text('Name: ${user['name']}'),
            Text('Email: ${user['email']}'),
            Text('Bio: ${user['bio']}'),
          ],
        ),
      ),
    );
  }
}
