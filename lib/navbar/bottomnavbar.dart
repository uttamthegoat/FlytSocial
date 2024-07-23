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
  late int activePage = 0;

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
      activePage = page;
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
        color: Colors.black,
        buttonBackgroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        items: [
          Icon(
            Icons.home,
            color: Colors.white,
            size: activePage == 0 ? 35 : 30,
          ),
          Icon(
            Icons.search,
            color: Colors.white,
            size: activePage == 1 ? 35 : 30,
          ),
          Icon(
            Icons.add,
            color: Colors.white,
            size: activePage == 2 ? 35 : 30,
          ),
          // Icon(
          //   Icons.info_outline,
          //   size: 30,
          // ),
          Icon(
            Icons.person,
            color: Colors.white,
            size: activePage == 3 ? 35 : 30,
          ),
        ],
        onTap: navigationTapped,
      )), // body: Screens[_selectedIndex],
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          Home(currentUser: curUser),
          const AppSearch(),
          NewPost(),
          // const About(),
          Profile(
            user: curUser,
          ),
        ],
      ),
    );
  }
}
