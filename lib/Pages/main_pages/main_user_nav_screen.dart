import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import '../main_pages/browse.dart';
import '../main_pages/profile.dart';
import '../main_pages/reference_screen.dart';
import '../main_pages/setting.dart';
import 'admin_home.dart';


const List<TabItem> items = [
  TabItem(icon: Icons.home_rounded),
  TabItem(icon: Symbols.quick_reference_all_rounded),
  TabItem(icon: Icons.person),
  TabItem(icon: Icons.settings),
];

class MainNavigationBarUserScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  const MainNavigationBarUserScreen({super.key, required this.setLocale});

  @override
  State<MainNavigationBarUserScreen> createState() =>
      _MainNavigationBarUserScreenState();
}

class _MainNavigationBarUserScreenState
    extends State<MainNavigationBarUserScreen> {
  int visit = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      BrowsePage(setLocale: widget.setLocale),
      ReferenceScreen(setLocale: widget.setLocale),
      Profile(setLocale: widget.setLocale),
      SettingsPage(setLocale: widget.setLocale),
    ];

    return Scaffold(
      backgroundColor: Color(0xffE9EDDE),
      body: IndexedStack(index: visit, children: pages),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10, right: 16, left: 16),
        child: Container(
          child: BottomBarFloating(
            borderRadius: BorderRadius.circular(101),
            items: items,
            iconSize: 40,
            backgroundColor: Color(
              0xff194E19,
            ), // Use transparent to blend with container
            color: Color(0XFFC3DEA9),
            colorSelected: Color(0xffE9EDDE),
            indexSelected: visit,
            onTap: (int index) {
              setState(() {
                visit = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
