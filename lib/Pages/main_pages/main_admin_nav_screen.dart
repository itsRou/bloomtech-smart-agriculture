import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'admin_home.dart';
import '../main_pages/reference_screen.dart';
import '../main_pages/profile.dart';
import '../main_pages/admin_setting.dart';
import '../main_pages/add_screen.dart';


class MainAdminNavScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  const MainAdminNavScreen({super.key, required this.setLocale});

  @override
  State<MainAdminNavScreen> createState() => _MainAdminNavScreenState();
}

const List<TabItem> items = [
  TabItem(
    icon: Icons.home_rounded,
  ),
  TabItem(
    icon: Symbols.quick_reference_all_rounded,
  ),
  TabItem(
    icon: Icons.add,
  ),
  TabItem(
    icon: Icons.person,
  ),
  TabItem(
    icon: Icons.settings,
  ),
];

class _MainAdminNavScreenState extends State<MainAdminNavScreen> {
  int visit = 0;

  @override
  Widget build(BuildContext context) {
      final List<Widget> pages = [
    Adminhome(setLocale: widget.setLocale),
    ReferenceScreen(setLocale: widget.setLocale),
    AddScreen(setLocale: widget.setLocale),
    Profile(setLocale: widget.setLocale),
    AdminSetting(setLocale: widget.setLocale),
  ];

    return Scaffold(
      backgroundColor: Color(0xffE9EDDE),
      body: IndexedStack(
        index: visit,
        children: pages,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10, right: 16, left: 16),
        child: Container(
          child: BottomBarCreative(
            borderRadius: BorderRadius.circular(101),
            items: items,
            iconSize: 40,
            backgroundColor:
                Color(0xff194E19), // Use transparent to blend with container
            color: Color(0XFFC3DEA9),
            colorSelected: Color(0xffE9EDDE),
            indexSelected: visit,
            isFloating: true,
            highlightStyle: const HighlightStyle(
                sizeLarge: true,
                background: Color(0XFFC3DEA9),
                color: Color(0xff194E19),
                elevation: 3),

            onTap: (int index) {
              if (index == 2) {
                // ✅ تنقل إلى AddScreen بدون الناف بار
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddScreen(setLocale: widget.setLocale),
                  ),
                );
              } else {
                // ✅ باقي التابات عادي داخل الناف بار
                setState(() {
                  visit = index;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
