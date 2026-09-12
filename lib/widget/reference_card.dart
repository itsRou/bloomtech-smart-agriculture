import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReferenceCard extends StatelessWidget {
  final String name;
  final String soilMoisture;
  final String temperature;
  final String light;
  final String imagePath;

  const ReferenceCard({
    
    Key? key,
    required this.name,
    required this.soilMoisture,
    required this.temperature,
    required this.light,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    return Container(
      width: 409,
      height: 260,
      
      decoration: BoxDecoration(
        color:  Color(0xFFEEF2E1),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset:  Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Row(
        
        children: [
          // Plant Info
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Color(0xFF194E19),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${localization.soil_moisture}: $soilMoisture",
                    style: const TextStyle(
                      color: Color(0xFF194E19),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "${localization.temperature}: $temperature",
                    style: const TextStyle(
                      color: Color(0xFF194E19),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "${localization.light}: $light",
                    style: const TextStyle(
                      color: Color(0xFF194E19),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Plant Image
          Image(image: AssetImage(imagePath),)
        ],
      ),
    );
  }
}