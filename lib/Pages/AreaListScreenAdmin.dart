import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'qr_scan_screen.dart';
import 'scan_page.dart';
import 'sensors_pages/sensor_screen.dart';

class AreaListScreenAdmin extends StatefulWidget {
  final Function(Locale) setLocale;
  const AreaListScreenAdmin({Key? key, required this.setLocale})
      : super(key: key);

  @override
  State<AreaListScreenAdmin> createState() => _AreaListScreenAdminState();
}

class _AreaListScreenAdminState extends State<AreaListScreenAdmin> {
  List<Map<String, String>> areas = [
    {"id": "1", "value": "50000"},
    {"id": "2", "value": "762537"},
    {"id": "3", "value": "092892"},
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    final filteredAreas = searchQuery.trim().isEmpty
        ? areas
        : areas.where((area) => area["value"] == searchQuery).toList();

    return Scaffold(
      backgroundColor: const Color(0xffE9EDDE),
      body: SafeArea(
        child: Column(
          children: [
            // ====== Header Buttons + Title ======
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: Column(
                children: [
                  // ==== Row 1: Back + Search ====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildBigIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      buildBigIconButton(
                        icon: Icons.search,
                        onPressed: () async {
                          final result = await showSearch(
                            context: context,
                            delegate: AreaSearchNoSuggestDelegate(areas: areas),
                          );

                          if (result != null && result.isNotEmpty) {
                            setState(() {
                              searchQuery = result;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ==== Row 2: Title + Scan ====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${localization.numberOfAreasTitle} ${filteredAreas.length}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff194E19),
                        ),
                      ),
                      buildBigIconButton(
                        icon: Symbols.camera_enhance_rounded,
                        onPressed: () {
                          // Scan action
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ScanPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ===== Area List =====
            Expanded(
              child: ListView.builder(
                itemCount: filteredAreas.length,
                itemBuilder: (context, index) {
                  final area = filteredAreas[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SensorScreen(setLocale: widget.setLocale)),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xffEEF2E1),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Area Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${localization.areaWithId} ${area["id"]}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Color(0xff194E19),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  area["value"]!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff194E19),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Image from assets
                          Image.asset(
                            'assets/images/area_icon.png',
                            width: 60,
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ===== Add Button =====
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF97BA75),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.add, size: 40),
          color: Color(0xffE9EDDE),
            // Add area action
            onPressed:
            () async {
              final newArea = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => QRScanScreen()),
              );

              if (newArea != null && mounted) {
                setState(() {
                  areas.add(Map<String, String>.from(newArea));
                });
              }
            },
          
        ),
      ),
    );
  }

  // 🔵 Big Icon Button with background image
  Widget buildBigIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/button_bg.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        icon: Icon(icon, size: 26),
        color: Color(0xff194E19),
        onPressed: onPressed,
      ),
    );
  }
}

class AreaSearchNoSuggestDelegate extends SearchDelegate<String> {
  final List<Map<String, String>> areas;

  AreaSearchNoSuggestDelegate({required this.areas});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isNotEmpty) {
      close(context, query);
    } else {
      close(context, ""); // ده بيرجع string فاضية => يجيب كل الـ areas
    }
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // No suggestions shown
    return const SizedBox.shrink();
  }
}
