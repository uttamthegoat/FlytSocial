import 'package:flutter/material.dart';
import 'package:flytsocial/state/user_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final dynamic user;
  const Home({super.key, required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    print(user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: FloatingActionButton(
              onPressed: () async =>
                  await Provider.of<UserProvider>(context, listen: false)
                      .signOut(),
            ),
          ),
        ),
      ),
    );
  }
}
