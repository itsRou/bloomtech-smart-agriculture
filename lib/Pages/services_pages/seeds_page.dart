import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../cart_provider.dart';
import 'cart_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SeedsPage extends StatefulWidget {
  final Function(Locale) setLocale;
  const SeedsPage({super.key, required this.setLocale});

  @override
  State<SeedsPage> createState() => _SeedsPageState();
}

class _SeedsPageState extends State<SeedsPage> {
  final List<_Seed> allSeeds = [
    _Seed('Tomato', 'طماطم', 'assets/images/tomato.jpg', 'Vegetables'),
    _Seed('Carrot', 'جزر', 'assets/images/carrot.png', 'Vegetables'),
    _Seed('Broccoli', 'بروكلي', 'assets/images/craffss.png', 'Vegetables'),
    _Seed('Strawberry', 'فراولة', 'assets/images/strawberry.jpg', 'Fruits'),
    _Seed('Zucchini', 'كوسة', 'assets/images/fresh-green-zucchini.png',
        'Vegetables'),
    _Seed('Celery', 'كرفس', 'assets/images/craffss.png', 'Vegetables'),
  ];
  final List<String> categories = ['All', 'Fruits', 'Vegetables'];
  String selectedCategory = 'All';
  final Map<String, int> selectedSeeds = {};
  final Map<String, TextEditingController> controllers = {};

  List<_Seed> get filteredSeeds => selectedCategory == 'All'
      ? allSeeds
      : allSeeds.where((s) => s.category == selectedCategory).toList();

  int get totalSelected => selectedSeeds.values.fold(0, (a, b) => a + b);

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6EA),
      appBar: AppBar(
        surfaceTintColor: const Color(0xFFEFF6EA),
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
                MaterialPageRoute(
                  builder: (context) =>  CartPage(setLocale: widget.setLocale),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFD9EAD3),
              child: Icon(Icons.search, color: Color(0xFF52734D)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              localization.seeds,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3A5A40),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  final isSelected = selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = cat;
                        });
                      },
                      selectedColor: const Color(0xFF52734D),
                      backgroundColor: const Color(0xFFD9EAD3),
                      labelStyle: TextStyle(
                        color:
                            isSelected ? Colors.white : Colors.green.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.95,
                children: filteredSeeds.map((seed) {
                  final count = selectedSeeds[seed.name] ?? 0;
                  controllers.putIfAbsent(seed.name,
                      () => TextEditingController(text: count.toString()));
                  controllers[seed.name]!.text = count.toString();
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Image.asset(
                              seed.imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.spa,
                                      size: 48, color: Color(0xFFB7E4C7)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          seed.name,
                          style: TextStyle(
                            color: Color(0xFF52734D),
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          seed.nameAr,
                          style: TextStyle(
                            color: Color(0xFF52734D),
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red, size: 28),
                              onPressed: count > 0
                                  ? () {
                                      setState(() {
                                        selectedSeeds[seed.name] = count - 1;
                                        if (selectedSeeds[seed.name]! < 0)
                                          selectedSeeds[seed.name] = 0;
                                      });
                                    }
                                  : null,
                            ),
                            SizedBox(
                              width: 50,
                              height: 32,
                              child: TextField(
                                controller: controllers[seed.name],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 4),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: localization.gramsLabel,
                                  labelStyle: const TextStyle(fontSize: 12),
                                ),
                                onChanged: (value) {
                                  final intValue = int.tryParse(value) ?? 0;
                                  setState(() {
                                    selectedSeeds[seed.name] =
                                        intValue < 0 ? 0 : intValue;
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: Colors.green, size: 28),
                              onPressed: () {
                                setState(() {
                                  selectedSeeds[seed.name] = count + 1;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    backgroundColor: const Color(0xFF52734D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  onPressed: totalSelected == 0
                      ? null
                      : () {
                          Provider.of<CartProvider>(context, listen: false)
                              .setSeeds(selectedSeeds);
                          ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                                content: Text(localization.addedToCart)),
                          );
                        },
                  child: Center(
                    child:  Text(localization.addToCart,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 1.1,
                    )),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _Seed {
  final String name;
  final String nameAr;
  final String imagePath;
  final String category;
  const _Seed(this.name, this.nameAr, this.imagePath, this.category);
}
