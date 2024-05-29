import 'package:flutter/material.dart';
import 'package:flytsocial/state/user_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvider>(context).user;
    final curUser = Provider.of<UserProvider>(context).curentUser;
    print(curUser);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      backgroundColor: Colors.purpleAccent,
      body: Container(
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(curUser['imageUrl']),
                ),
              ),
            ),
            Text(curUser['email']),
            Text(curUser['name']),
            MaterialButton(
              color: Colors.red,
              onPressed: () async =>
                  await Provider.of<UserProvider>(context, listen: false)
                      .signOut(),
              child: const Text("Sign Out"),
            )
          ],
        ),
      ),
    );
  }
}
