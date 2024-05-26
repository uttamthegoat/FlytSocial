import 'package:flutter/material.dart';
import 'package:flytsocial/navbar/bottomnavbar.dart';
import 'package:flytsocial/state/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';

class AppAuth extends StatefulWidget {
  const AppAuth({super.key});

  @override
  State<AppAuth> createState() => _HomePageState();
}

class _HomePageState extends State<AppAuth> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: user == null?AppBar(
        title: const Text("Google SignIn"),
      ):null,
      body: user != null ? const BottomNavBar() : _googleSignInButton(context),
    );
  }

  Widget _googleSignInButton(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.google,
          text: "Sign up with Google",
          onPressed: ()async{
            await Provider.of<UserProvider>(context, listen: false).signIn();
          },
        ),
      ),
    );
  }
}
