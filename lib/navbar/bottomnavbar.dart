import 'package:flutter/material.dart';
import 'package:flytsocial/screens/about.dart';
import 'package:flytsocial/screens/home.dart';
import 'package:flytsocial/screens/new_post.dart';
import 'package:flytsocial/screens/profile.dart';
import 'package:flytsocial/screens/search.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flytsocial/state/user_provider.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

int _currentIndex = 0;

class _BottomNavBarState extends State<BottomNavBar> {
  late PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    final curUser = Provider.of<UserProvider>(context).currentUser;
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      bottomNavigationBar: Container(
          child: CurvedNavigationBar(
        index: _currentIndex,
        backgroundColor: Color.fromARGB(179, 128, 127, 127),
        items: const [
          Icon(
            Icons.home,
            size: 30,
          ),
          Icon(
            Icons.search,
            size: 30,
          ),
          Icon(
            Icons.add,
            size: 30,
          ),
          Icon(
            Icons.info_outline,
            size: 30,
          ),
          Icon(
            Icons.person,
            size: 30,
          ),
        ],
        onTap: navigationTapped,
      )), // body: Screens[_selectedIndex],
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          Home(user: curUser),
          const AppSearch(),
          NewPost(),
          const About(),
          Profile(
            user: curUser,
          ),
        ],
      ),
    );
  }
}
