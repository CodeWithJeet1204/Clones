import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_variables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    setState(() {
      pageController.jumpToPage(page);
    });
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: webBackgroundColor,
        title: SvgPicture.asset(
          'assets/insta_logo.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () => navigationTapped(0),
            tooltip: "Home",
            icon: const Icon(Icons.home),
            color: _page == 0 ? primaryColor : secondaryColor,
          ),
          IconButton(
            onPressed: () => navigationTapped(1),
            tooltip: "Search",
            icon: const Icon(Icons.search),
            color: _page == 1 ? primaryColor : secondaryColor,
          ),
          IconButton(
            onPressed: () => navigationTapped(2),
            tooltip: "Add Post",
            icon: const Icon(Icons.add_circle_outline_outlined),
            color: _page == 2 ? primaryColor : secondaryColor,
          ),
          IconButton(
            onPressed: () => navigationTapped(3),
            tooltip: "Favorite",
            icon: const Icon(Icons.favorite),
            color: _page == 3 ? primaryColor : secondaryColor,
          ),
          IconButton(
            onPressed: () => navigationTapped(4),
            tooltip: "Profile",
            icon: const Icon(Icons.person),
            color: _page == 4 ? primaryColor : secondaryColor,
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
    );
  }
}
