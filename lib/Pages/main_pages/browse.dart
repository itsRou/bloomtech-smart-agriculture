import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widget/buildFilterBar.dart';
import '../../widget/build_icon.dart';
import '../../widget/clicked_container.dart';
import '../AreaListScreenUser.dart';
import '../notifications.dart';
import '../user_planet_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BrowsePage extends StatefulWidget {
  final Function(Locale) setLocale;
  const BrowsePage({Key? key, required this.setLocale}) : super(key: key);

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Color(0xFFE9EDDE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 600;
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Top Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "${localization.findYour} \n",
                                style: GoogleFonts.k2d(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.green.shade800,
                                ),
                              ),
                              TextSpan(
                                text: localization.favoritePlant,
                                style: GoogleFonts.k2d(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF194E19),
                                ),
                              ),
                            ],
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          buildFilterButton(localization.allPlants,
                              isSelected: true, isSmallScreen: isSmallScreen),
                          buildFilterButton(localization.indoorPlants,
                              isSmallScreen: isSmallScreen),
                          buildFilterButton(localization.outdoorPlants,
                              isSmallScreen: isSmallScreen),
                          buildFilterButton(localization.aromaticPlants,
                              isSmallScreen: isSmallScreen),
                        ],
                      ),
                    ),
                    SizedBox(height: 90),
                    clickedContainer(
                      isSmallScreen: isSmallScreen,
                      constraints: constraints,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AreaListScreen(setLocale: widget.setLocale)),
                        );
                      },
                    ),
                    SizedBox(height: 90),
                    clickedContainer(
                      isSmallScreen: isSmallScreen,
                      constraints: constraints,
                      onPressed: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AreaListScreen(setLocale: widget.setLocale)),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      // Floating Action Bar

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Handle FAB action
      //   },
      //   backgroundColor: const Color(0xFFC3DEA9),
      //   child: Icon(Icons.add, color: Colors.green.shade800),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
