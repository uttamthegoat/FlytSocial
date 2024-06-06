import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flytsocial/firebase_options.dart';
import 'package:flytsocial/navbar/bottomnavbar.dart';
import 'package:flytsocial/screens/auth.dart';
import 'package:flytsocial/screens/post_item.dart';
import 'package:flytsocial/screens/users_profile.dart';
import 'package:flytsocial/state/auth_state_provider.dart';
import 'package:flytsocial/state/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthStateProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final isAuthenicated = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlytSocial',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const _AppWrapper(),
      routes: {
        '/auth': (context) => const AppAuth(),
        '/home': (context) => const MainApp(),
        '/postitem': (context) => const PostItem(),
        '/userprofile': (context) =>  UserProfile(),
      },
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AppWrapper();
  }
}

class _AppWrapper extends StatefulWidget {
  const _AppWrapper({super.key});

  @override
  State<_AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<_AppWrapper> {
  @override
  Widget build(BuildContext context) {
    bool isAuthenticated =
        Provider.of<AuthStateProvider>(context).isAuthenticated;
    return isAuthenticated ? const BottomNavBar() : const AppAuth();
  }
}
