import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sidekick/pages/home.dart';
import 'package:sidekick/pages/messages.dart';
import 'package:sidekick/pages/nutrition.dart';
import 'package:sidekick/pages/profile.dart';
import 'package:sidekick/providers/user_provider.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final PageController _pageController = PageController();

  bool partnerFound = false;

  int _selectedIndex = 0;

  void _onPageChanged(int page) {
    setState(() {
      _selectedIndex = page;
    });
  }

  void _onTapped(int page) {
    if (partnerFound) {
      _pageController.jumpToPage(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    partnerFound = context.watch<UserProvider>().isPartnerFound;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Home(pageController: _pageController),
          const Messages(),
          const Stats(),
          const Profile(),
        ],
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        onTap: partnerFound ? _onTapped : null,
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.home,
              color: _selectedIndex == 0 ? Colors.purple : Colors.grey,
            ),
            label: ('Home'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.comments,
              color: _selectedIndex == 1 ? Colors.purple : Colors.grey,
            ),
            label: ('Search'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.utensils,
              color: _selectedIndex == 2 ? Colors.purple : Colors.grey,
            ),
            label: ('Profile'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.user,
              color: _selectedIndex == 3 ? Colors.purple : Colors.grey,
            ),
            label: ('Settings'),
          ),
        ],
      ),
    );
  }
}
