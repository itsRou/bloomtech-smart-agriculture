import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helper/dimintions.dart';
import '../../widget/reference_card.dart';


class ReferenceScreen extends StatefulWidget {
final Function(Locale) setLocale;
  const ReferenceScreen({super.key, required this.setLocale});

  @override
  State<ReferenceScreen> createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen> {
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
     final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    double spacesHeight(double number) {
      double space = (number / heightRatio) * height;
      return space;
    }

    double spacesWidth(double number) {
      double space = (number / widthRatio) * width;
      return space;
    }
    return Scaffold(
      backgroundColor: Color(0xFFEEF2E1),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
           padding: EdgeInsets.symmetric(horizontal: spacesWidth(39)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(
                  height: spacesHeight(60),
                ),
               
                SizedBox(
                  height: spacesHeight(10),
                ),
                 ReferenceCard(
                    name: localization.mint,
                    soilMoisture: "45%",
                    temperature: "22 C",
                    light: "1200 lux",
                    imagePath: "assets/images/planet.png", // Replace with your asset path
                  ),
                  SizedBox(height: 16),
                  ReferenceCard(
                    name: localization.thyme,
                    soilMoisture: "45%",
                    temperature: "40 C",
                    light: "2000 lux",
                    imagePath: "assets/images/plant2.png", // Replace with your asset path
                  ),
                  SizedBox(height: 16),
                  ReferenceCard(
                    name: localization.basil,
                    soilMoisture: "60%",
                    temperature: "30 C",
                    light: "1500 lux",
                    imagePath: "assets/images/plant3.png", // Replace with your asset path
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}