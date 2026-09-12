import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widget/build_icon.dart';
import '../../widget/clicked_container.dart';
import '../AreaListScreenAdmin.dart';
import '../notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Adminhome extends StatefulWidget {
  final Function(Locale) setLocale;
  const Adminhome({Key? key, required this.setLocale}) : super(key: key);

  @override
  State<Adminhome> createState() => _AdminhomeState();
}

class _AdminhomeState extends State<Adminhome> {

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFE9EDDE),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 600;

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Section

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localization.checkoutPlants,
                        style: GoogleFonts.k2d(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF194E19),
                        ),
                      ),
                      Column(
                          children: [
                            buildIconButton(Icons.notifications, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NotificationsScreen(setLocale: widget.setLocale)),
                              );
                            }),
                            SizedBox(height: 16),
                            //buildIconButton(Icons.search, () {}),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Category Filters

                  const SizedBox(height: 50),
                  clickedContainer(
                    isSmallScreen: isSmallScreen,
                    constraints: constraints,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AreaListScreenAdmin(setLocale: widget.setLocale)),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      // Floating Action Bar
    );
  }

  Widget buildUsefulIconButton(IconData icon, bool isSmallScreen) {
    // notification and search icons in the top
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFC3DEA9),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.green.shade800),
        iconSize: isSmallScreen ? 30 : 36,
        onPressed: () {},
      ),
    );
  }
}
