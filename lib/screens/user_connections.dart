import 'package:flutter/material.dart';

class UserConnections extends StatefulWidget {
  const UserConnections({super.key});

  @override
  State<UserConnections> createState() => _UserConnectionsState();
}

class _UserConnectionsState extends State<UserConnections> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My connections'),
      ),
    );
  }
}