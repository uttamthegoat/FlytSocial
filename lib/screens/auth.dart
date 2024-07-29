import 'package:flutter/material.dart';
import 'package:flytsocial/navbar/bottomnavbar.dart';
import 'package:flytsocial/screens/welcome_page.dart';
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
      appBar: user == null ? AppBar() : null,
      body: user != null ? const MainPage() : _AuthPage(context),
    );
  }

  Widget _AuthPage(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Welcome to',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
          ),
          Column(
            children: <Widget>[
              Image.asset(
                'assets/applogo.png', // Replace with your logo image path
                height: 300.0,
                width: 300.0,
              ),
              const Text(
                'FlytSocial',
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 90),
          SizedBox(
            height: 50,
            width: 250,
            child: SignInButton(
              Buttons.google,
              text: "Sign up with Google",
              elevation: 20,
              onPressed: () async {
                await Provider.of<UserProvider>(context, listen: false)
                    .signIn();
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              'assets/auth_page_design.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  // Widget firstLog(BuildContext context) {
  //   print(" this is the current user"+Provider.of<UserProvider>(context).currentUser);
  //   return FutureBuilder<void>(
  //     future: userFuture,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       } else {
  //         return const BottomNavBar(); // Replace with your BottomNavBar widget
  //       }
  //     },
  //   );
  // }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainPage> {
  late Future<void> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = initializeUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (Provider.of<UserProvider>(context).firstTime) {
              return WelcomePage();
            } else {
              return const BottomNavBar();
            }
          }
        },
      ),
    );
  }

  Future<void> initializeUser() async {
    await Provider.of<UserProvider>(context, listen: false).setUserInfo();
  }
}
