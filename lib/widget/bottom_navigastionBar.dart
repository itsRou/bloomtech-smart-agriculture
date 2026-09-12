import 'package:flutter/material.dart';

import 'nav_bar.dart';

class bottomNavigationBar extends StatelessWidget {
  const bottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        child: BottomAppBar(
          height: 66,
          notchMargin: 10,
          color: const Color(0xFF194E19),
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              navBarIcon(Icons.home, isSelected: true),
              navBarIcon(Icons.file_copy),
              navBarIcon(Icons.person),
              navBarIcon(Icons.settings),
            ],
          ),
        ),
      ),
    );
  }
}