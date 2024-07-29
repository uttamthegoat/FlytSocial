import 'package:flutter/material.dart';
import 'package:flytsocial/navbar/bottomnavbar.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool home = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: home?
      const BottomNavBar()
      :Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    home = true;
                  });
                },
                child: const Icon(Icons.close)),
            const Text('Welcome to FlytSocial'),
            const SizedBox(
              height: 20,
            ),
            const Text('Hope you have a wonderful experience!')
          ],
        ),
      ),
    );
  }
}
