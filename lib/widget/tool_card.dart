import 'package:flutter/material.dart';

class ToolCard extends StatelessWidget {
  final String tool;
  final int count;
  final TextEditingController controller;
  final String imagePath;
  final VoidCallback? onMinus;
  final VoidCallback onPlus;
  final ValueChanged<String> onChanged;

  const ToolCard({
    super.key,
    required this.tool,
    required this.count,
    required this.controller,
    required this.imagePath,
    required this.onMinus,
    required this.onPlus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2E1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tool,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Image.asset(
                  imagePath,
                  height: 150,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.build, size: 60, color: Colors.grey),
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
                    onChanged: onChanged,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle,
                      color: Colors.green, size: 28),
                  onPressed: onPlus,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
