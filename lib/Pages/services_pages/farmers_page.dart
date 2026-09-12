import 'package:flutter/material.dart';
import '../../cart_provider.dart';
import 'cart_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FarmersPage extends StatefulWidget {
  final Function(Locale) setLocale;
  const FarmersPage({super.key, required this.setLocale});

  @override
  State<FarmersPage> createState() => _FarmersPageState();
}

class _FarmersPageState extends State<FarmersPage> {
  final TextEditingController farmersController = TextEditingController();
  final TextEditingController areaController = TextEditingController();

  @override
  void dispose() {
    farmersController.dispose();
    areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    final TextEditingController farmersController = TextEditingController();
    final TextEditingController areaController = TextEditingController();
    return Scaffold(
      backgroundColor: const Color(0xFFEFF2E1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF7A9D54)),
          onPressed: () => Navigator.pop(context),
        ),

        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Color(0xFF52734D)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(setLocale: widget.setLocale)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              localization.farmers,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3A5A40),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
             Text(localization.farmersDescription,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 13.5,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            _InputCard(
              label: localization.numberOfFarmers,
              controller: farmersController,
            ),
            const SizedBox(height: 20),
            _InputCard(label: localization.areaSize, controller: areaController),
            const Spacer(),
            Center(
              child: SizedBox(
                width: 180,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF52734D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    final count = int.tryParse(farmersController.text) ?? 0;
                    final area = areaController.text;
                    Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).setFarmers(count, area);
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text(localization.addToCart)),
                    );
                  },
                  child:  Text(
                    localization.addToCart,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _InputCard({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2E1),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF52734D),
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 80,
              height: 36,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFB7E4C7)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFB7E4C7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF52734D), width: 2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
