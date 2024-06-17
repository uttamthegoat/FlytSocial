import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flytsocial/firebase_options.dart';
import 'package:flytsocial/navbar/bottomnavbar.dart';
import 'package:flytsocial/routes/app_routes_config.dart';
import 'package:flytsocial/screens/auth.dart';
import 'package:flytsocial/state/auth_state_provider.dart';
import 'package:flytsocial/state/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      home: const ScreenUtilInit(designSize: Size(375, 812), child: MainPage()),
      routes: allRoutes,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainPage> {
  late Map<String, dynamic> curUser;

  @override
  void initState() {
    super.initState();
    initializeUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const BottomNavBar();
          } else {
            return const AppAuth();
          }
        },
      ),
    );
  }

  initializeUser() async {
    await Provider.of<UserProvider>(context, listen: false).setUserInfo();
  }
}
