import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'scan_page.dart';
import 'sensors_pages/sensor_screen.dart';

class AreaListScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  const AreaListScreen({Key? key, required this.setLocale}) : super(key: key);

  @override
  State<AreaListScreen> createState() => _AreaListScreenState();
}

class _AreaListScreenState extends State<AreaListScreen> {
  List<Map<String, String>> areas = [];
  bool _loading = true;

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadAreas();
  }

  Future<void> _loadAreas() async {
    try {
      final snapshot = await FirebaseDatabase.instance.ref('areas').get();
      final loaded = <Map<String, String>>[];
      if (snapshot.exists && snapshot.value is Map) {
        final data = Map<dynamic, dynamic>.from(snapshot.value as Map);
        data.forEach((key, value) {
          if (value is Map) {
            loaded.add({
              "id": key.toString(),
              "value": (value['name'] ?? '').toString(),
            });
          }
        });
      }
      if (mounted) {
        setState(() {
          areas = loaded;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    final filteredAreas =
        searchQuery.isEmpty
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
                          MaterialPageRoute(
                              builder: (context) => ScanPage()),
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
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredAreas.isEmpty
                      ? Center(
                          child: Text(
                            "No areas registered yet.",
                            style: TextStyle(color: Color(0xff194E19)),
                          ),
                        )
                      : ListView.builder(
                itemCount: filteredAreas.length,
                itemBuilder: (context, index) {
                  final area = filteredAreas[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  SensorScreen(setLocale: widget.setLocale),
                        ),
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
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff194E19),
                                  ),
                                ),
                                Text(
                                  area["value"]!,
                                  style: const TextStyle(fontSize: 18),
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
    if (query.isNotEmpty) {
      close(context, query); // بيرجع القيمة
    }
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // No suggestions shown
    return const SizedBox.shrink();
  }
}
