import 'package:flutter/material.dart';
import 'package:flytsocial/screens/about.dart';
import 'package:flytsocial/screens/home.dart';
import 'package:flytsocial/screens/new_post.dart';
import 'package:flytsocial/screens/profile.dart';
import 'package:flytsocial/screens/search.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List Screens = [
    const Home(),
    const AppSearch(),
    const NewPost(),
    const About(),
    const Profile(),
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      bottomNavigationBar: CurvedNavigationBar(
              index: _selectedIndex,
              backgroundColor: Colors.transparent,
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
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
      body: Screens[_selectedIndex],
    );
  }
}
