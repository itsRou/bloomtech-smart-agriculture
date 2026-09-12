import 'package:flutter/material.dart';
import '../../cart_provider.dart';
import '../../widget/tool_card.dart';
import 'cart_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ToolsPage extends StatefulWidget {
  final Function(Locale) setLocale;
  const ToolsPage({super.key, required this.setLocale});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  final List<String> tools = [
    'Pruning Shears',
    'Shovel',
    'Weeding Knife',
    'Wheel Barrow',
    'Hand Saw',
    'Garden Fork',
  ];
  final Map<String, int> selectedTools = {};
  final Map<String, TextEditingController> controllers = {};

  int get totalSelected => selectedTools.values.fold(0, (a, b) => a + b);

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
        surfaceTintColor: Color(0xFFEFF2E1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFFEFF2E1),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localization.tools,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.green.shade900, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
                children: tools.map((tool) {
                  final count = selectedTools[tool] ?? 0;
                  controllers.putIfAbsent(tool,
                      () => TextEditingController(text: count.toString()));
                  controllers[tool]!.text = count.toString();
                  String imagePath;
                  switch (tool) {
                    case 'Pruning Shears':
                      imagePath = 'assets/images/pruning_shears.png';
                      break;
                    case 'Shovel':
                      imagePath = 'assets/images/shovel.png';
                      break;
                    case 'Weeding Knife':
                      imagePath = 'assets/images/weeding_knife.png';
                      break;
                    case 'Wheel Barrow':
                      imagePath = 'assets/images/wheel_barrow.png';
                      break;
                    case 'Hand Saw':
                      imagePath = 'assets/images/hand_saw.png';
                      break;
                    case 'Garden Fork':
                      imagePath = 'assets/images/garden_fork.png';
                      break;
                    default:
                      imagePath = 'assets/images/tool.png';
                  }
                  return ToolCard(
                    tool: tool,
                    count: count,
                    controller: controllers[tool]!,
                    imagePath: imagePath,
                    onMinus: count > 0
                        ? () {
                            setState(() {
                              selectedTools[tool] = count - 1;
                              if (selectedTools[tool]! < 0)
                                selectedTools[tool] = 0;
                            });
                          }
                        : null,
                    onPlus: () {
                      setState(() {
                        selectedTools[tool] = count + 1;
                      });
                    },
                    onChanged: (value) {
                      final intValue = int.tryParse(value) ?? 0;
                      setState(() {
                        selectedTools[tool] = intValue < 0 ? 0 : intValue;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF52734D),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                onPressed: totalSelected == 0
                    ? null
                    : () {
                        Provider.of<CartProvider>(context, listen: false)
                            .setTools(selectedTools);
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text(localization.addedToCart)),
                        );
                      },
                child:  Text(localization.addToCart,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 1.1,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
