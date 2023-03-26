import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pawssion/navigation/screens/donate/donate.dart';
import 'package:pawssion/navigation/screens/media/media.dart';
import 'package:pawssion/navigation/screens/posts/posts.dart';
import 'package:pawssion/navigation/screens/profile/profile.dart';
import 'package:pawssion/utils/colors.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  var padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 5);
  double gap = 10;
  List body = [
    const DonateScreen(),
    const PostsScreen(),
    const MediaScreen(),
    const ProfileScreen()
  ];
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: CustomColors.primaryBackground,
      body: PageView.builder(
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              _selectedIndex = page;
            });
          },
          itemCount: 4,
          itemBuilder: (context, position) {
            return body[position];
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: CustomColors.auxilliaryContent,
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              BoxShadow(
                spreadRadius: -10,
                blurRadius: 60,
                offset: const Offset(0, 25),
                color: Colors.black.withOpacity(0.4),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: GNav(
              curve: Curves.fastOutSlowIn,
              duration: const Duration(milliseconds: 900),
              tabs: [
                navBarButtons(
                  Icons.pets,
                  "Petify",
                  CustomColors.primaryContent,
                ),
                navBarButtons(
                  Icons.post_add,
                  "Posts",
                  CustomColors.primaryContent,
                ),
                navBarButtons(
                  Icons.video_collection,
                  "Media",
                  CustomColors.primaryContent,
                ),
                navBarButtons(
                  Icons.person,
                  "Me",
                  CustomColors.primaryContent,
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                _pageController.jumpToPage(index);
              },
            ),
          ),
        ),
      ),
    );
  }

  navBarButtons(IconData iconData, String text, Color backgroundColor) {
    return GButton(
      icon: iconData,
      iconColor: Colors.white38,
      iconActiveColor: CustomColors.secondaryContent,
      text: text,
      textStyle: const TextStyle(
        fontFamily: 'CarterOne',
        letterSpacing: 1.5,
        color: CustomColors.secondaryContent,
      ),
      backgroundColor: backgroundColor,
      iconSize: 24,
      padding: padding,
      gap: gap,
    );
  }
}
