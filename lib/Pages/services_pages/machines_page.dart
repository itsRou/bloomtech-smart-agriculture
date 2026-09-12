import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'package:provider/provider.dart';
import '../../cart_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MachinesPage extends StatefulWidget {
  final Function(Locale) setLocale;
  const MachinesPage({super.key, required this.setLocale});

  @override
  State<MachinesPage> createState() => _MachinesPageState();
}

class _MachinesPageState extends State<MachinesPage> {
  final List<_Machine> machines = [
    _Machine('Tractor', 'assets/images/powerful-red.png'),
    _Machine('Trailer', 'assets/images/lawn-mower.png'),
    _Machine('Seed Drill', 'assets/images/yellow-excavator.png'),
    _Machine('Harvester', 'assets/images/white-semitrailer-truck.png'),
    _Machine('Hand Saw', 'assets/images/tractor-working.png'),
    _Machine('Garden Fork', 'assets/images/powerful-green.png'),
  ];
  final Map<String, int> selectedMachines = {};
  final Map<String, TextEditingController> controllers = {};

  int get totalSelected => selectedMachines.values.fold(0, (a, b) => a + b);

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
      backgroundColor: const Color(0xFFEFF2E1),
      appBar: AppBar(
        surfaceTintColor:  Color(0xFFEFF2E1),
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
                  builder: (context) => CartPage(setLocale: widget.setLocale),
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
              localization.machines,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3A5A40),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 1.1,
                children: machines.map((machine) {
                  final count = selectedMachines[machine.name] ?? 0;
                  controllers.putIfAbsent(machine.name,
                      () => TextEditingController(text: count.toString()));
                  controllers[machine.name]!.text = count.toString();
                  return _MachineCard(
                    machine: machine,
                    count: count,
                    onPlus: () {
                      setState(() {
                        selectedMachines[machine.name] = count + 1;
                      });
                    },
                    onMinus: () {
                      if (count > 0) {
                        setState(() {
                          selectedMachines[machine.name] = count - 1;
                        });
                      }
                    },
                    controller: controllers[machine.name]!,
                    onCountChanged: (value) {
                      final intValue = int.tryParse(value) ?? 0;
                      setState(() {
                        selectedMachines[machine.name] =
                            intValue < 0 ? 0 : intValue;
                      });
                    },
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
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
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
                              .setMachines(selectedMachines);
                          ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                                content: Text(localization.addedToCart)),
                          );
                        },
                  child:   Text(localization.addToCart,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 1.1,
                    )),
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

class _Machine {
  final String name;
  final String imagePath;
  const _Machine(this.name, this.imagePath);
}

class _MachineCard extends StatelessWidget {
  final _Machine machine;
  final int count;
  final VoidCallback onPlus;
  final VoidCallback onMinus;
  final TextEditingController controller;
  final ValueChanged<String> onCountChanged;
  const _MachineCard(
      {required this.machine,
      required this.count,
      required this.onPlus,
      required this.onMinus,
      required this.controller,
      required this.onCountChanged});

  @override
  Widget build(BuildContext context) {
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
          Text(
            machine.name,
            style: TextStyle(
              color: Color(0xFF52734D),
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(
                machine.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.agriculture,
                    size: 48,
                    color: Color(0xFFB7E4C7)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle,
                    color: Colors.red, size: 28),
                onPressed: onMinus,
              ),
              SizedBox(
                width: 40,
                height: 32,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: onCountChanged,
                ),
              ),
              IconButton(
                icon:
                    const Icon(Icons.add_circle, color: Colors.green, size: 28),
                onPressed: onPlus,
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
