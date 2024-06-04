import 'package:flutter/material.dart';
import 'package:flytsocial/state/user_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  void _navToSearch(BuildContext context) {
    Navigator.pushNamed(context, '/postitem');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      backgroundColor: Colors.blue,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Home Page'),
              FloatingActionButton(
                onPressed: () => _navToSearch(context),
                tooltip: 'Search',
                child: const Icon(Icons.search),
              ),
              FloatingActionButton(
                onPressed: ()async => await Provider.of<UserProvider>(context, listen: false)
                      .signOut(),
                tooltip: 'Search',
                child: const Icon(Icons.search),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
