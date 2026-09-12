import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../admin_provider.dart';
import '../../cart_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Map<String, String> itemImages = {
  'Tomato': 'assets/images/tomato.jpg',
  'Carrot': 'assets/images/carrot.png',
  'Broccoli': 'assets/images/craffss.png',
  'Strawberry': 'assets/images/strawberry.jpg',
  'Zucchini': 'assets/images/fresh-green-zucchini.png',
  'Celery': 'assets/images/craffss.png',
  'Farmers': 'assets/images/farmer.png',
  'Wheel Barrow': 'assets/images/wheel_barrow.png',
  // Add more items as needed
};

class CartPage extends StatefulWidget {
  final Function(Locale) setLocale;
  const CartPage({super.key, required this.setLocale});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    final cartData = Provider.of<CartProvider>(context).cartData;
    final farmers = cartData['farmers'] as Map<String, dynamic>?;
    final tools = cartData['tools'] as Map<String, int>?;
    final machines = cartData['machines'] as Map<String, int>?;
    final seeds = cartData['seeds'] as Map<String, int>?;
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEFF6EA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF7A9D54)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(localization.yourCart,
            style: TextStyle(color: Colors.black54, fontSize: 16)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              localization.yourCart,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3A5A40),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView(
                children: [
                  if (seeds != null && seeds.isNotEmpty)
                    ...seeds.entries.where((e) => e.value > 0).map(
                          (e) => CartItemCard(
                            imagePath:
                                itemImages[e.key] ?? 'assets/images/seeds.png',
                            name: e.key,
                            quantity: e.value,
                            onAdd: () => cartProvider.incrementSeed(e.key),
                            onRemove: () => cartProvider.decrementSeed(e.key),
                          ),
                        ),
                  if (machines != null && machines.isNotEmpty)
                    ...machines.entries.where((e) => e.value > 0).map(
                          (e) => CartItemCard(
                            imagePath: itemImages[e.key] ??
                                'assets/images/machine.png',
                            name: e.key,
                            quantity: e.value,
                            onAdd: () => cartProvider.incrementMachine(e.key),
                            onRemove: () =>
                                cartProvider.decrementMachine(e.key),
                          ),
                        ),
                  if (farmers != null && (farmers['count'] ?? 0) > 0)
                    CartItemCard(
                      imagePath:
                          itemImages['Farmers'] ?? 'assets/images/farmer.png',
                      name: 'Farmers',
                      quantity: farmers['count'],
                      onAdd: () => cartProvider.incrementFarmers(),
                      onRemove: () => cartProvider.decrementFarmers(),
                    ),
                  if (tools != null && tools.isNotEmpty)
                    ...tools.entries.where((e) => e.value > 0).map(
                          (e) => CartItemCard(
                            imagePath:
                                itemImages[e.key] ?? 'assets/images/tools.png',
                            name: e.key,
                            quantity: e.value,
                            onAdd: () => cartProvider.incrementTool(e.key),
                            onRemove: () => cartProvider.decrementTool(e.key),
                          ),
                        ),
                  if ((farmers == null || (farmers['count'] ?? 0) == 0) &&
                      (tools == null || tools.isEmpty) &&
                      (machines == null || machines.isEmpty) &&
                      (seeds == null || seeds.isEmpty))
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text(localization.cartIsEmpty,
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: 180,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF52734D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    // Confirm order logic here
                    saveCartToFirestore(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(localization.orderConfirmed),
                        content: Text(localization.orderPlaced),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(localization.ok),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    localization.confirmOrder,
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
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  void saveCartToFirestore(BuildContext context) async {
  final adminId = Provider.of<AdminProvider>(context, listen: false).adminId;

  if (adminId == null) {
    print("⚠️ Admin ID not available.");
    return;
  }

  final cartProvider = Provider.of<CartProvider>(context, listen: false);
  final cartData = cartProvider.cartData;

  final Map<String, dynamic> dataToSave = {
    "timestamp": Timestamp.now(),
  };

  if ((cartData["farmers"] as Map).isNotEmpty) {
    dataToSave["farmers"] = cartData["farmers"];
  }

  if ((cartData["tools"] as Map).isNotEmpty) {
    dataToSave["tools"] = cartData["tools"];
  }

  if ((cartData["machines"] as Map).isNotEmpty) {
    dataToSave["machines"] = cartData["machines"];
  }

  if ((cartData["seeds"] as Map).isNotEmpty) {
    dataToSave["seeds"] = cartData["seeds"];
  }

  try {
    final firestore = FirebaseFirestore.instance;

    await firestore
        .collection("admins")
        .doc(adminId)
        .collection("services")
        .doc("order_${DateTime.now().millisecondsSinceEpoch}")
        .set(dataToSave);

    print("✅ Order saved under admin ID: $adminId");
    cartProvider.clearCart();
  } catch (e) {
    print("❌ Failed to save order: $e");
  }
}


}



class _CartSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _CartSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF52734D),
              fontWeight: FontWeight.w700,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final String name;
  final String value;
  const _CartItem({required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontSize: 16)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const CartItemCard({
    required this.imagePath,
    required this.name,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6EA), // light green background
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(imagePath, width: 60, height: 60),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF3A5A40),
              ),
            ),
          ),
          Row(
            children: [
              // Minus button
              Ink(
                decoration: const ShapeDecoration(
                  color: Color(0xFFB6D7B9), // light green
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.remove, color: Color(0xFF3A5A40)),
                  onPressed: onRemove,
                  splashRadius: 22,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '$quantity',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF3A5A40),
                  ),
                ),
              ),
              // Plus button
              Ink(
                decoration: const ShapeDecoration(
                  color: Color(0xFFB6D7B9), // light green
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFF3A5A40)),
                  onPressed: onAdd,
                  splashRadius: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
