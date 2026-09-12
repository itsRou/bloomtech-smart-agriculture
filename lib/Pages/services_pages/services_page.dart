import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'farmers_page.dart';
import 'machines_page.dart';
import 'seeds_page.dart';
import 'tools_page.dart';

class ServicesPage extends StatefulWidget {
  final Function(Locale) setLocale;
  const ServicesPage({super.key, required this.setLocale});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFEFF2E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFF2E1),
        surfaceTintColor: const Color(0xFFEFF2E1),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Color(0xFF52734D)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(setLocale: widget.setLocale),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text(localization.services,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.green.shade900,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _ServiceCard(
                title: localization.farmers,
                onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FarmersPage(setLocale:  widget.setLocale),
                ),
              );
            },
                imagePath: 'assets/images/farmersBackgorund.jpg',
              ),
              const SizedBox(height: 16),
              _ServiceCard(
                title: localization.tools,
                onTap: ()  {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ToolsPage(setLocale:  widget.setLocale),
                ),
              );
            },
                imagePath: 'assets/images/toolsBackground.jpg',
              ),
              const SizedBox(height: 16),
              _ServiceCard(
                title: localization.machines,
                onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MachinesPage(setLocale:  widget.setLocale),
                ),
              );
            },
                imagePath: 'assets/images/machineBackground.jpg',
              ),
              const SizedBox(height: 16),
              _ServiceCard(
                title: localization.seeds,
                onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SeedsPage(setLocale:  widget.setLocale),
                ),
              );
            },
                imagePath: 'assets/images/seedsBackgroud.jpg',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final String imagePath;

  const _ServiceCard({
    required this.title,
    required this.onTap,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.15),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
