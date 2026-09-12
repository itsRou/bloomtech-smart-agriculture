import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../helper/dimintions.dart';

class clickedContainer extends StatelessWidget {
  const clickedContainer({
    super.key,
    required this.isSmallScreen,
    required this.constraints, required this.onPressed,
  });

  final bool isSmallScreen;
  final BoxConstraints constraints;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    // Get screen width and height
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
    

    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: spacesHeight(370),
            width: spacesWidth(380),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 200, 231, 170),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.only(
                top: 150, left: 16, right: 16, bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // The plant name and arrow button below the image
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localization.mint,
                      style: GoogleFonts.k2d(
                        fontSize: isSmallScreen ? 40 : 50,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF224821),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF194E19),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        iconSize: isSmallScreen ? 30 : 36,
                        onPressed:  onPressed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: -50, // Adjust the position of the image
            left: 15,
            child: Image.asset(
              "assets/images/plant.png", // Replace with actual plant image
              height: spacesHeight(320),
              width: spacesWidth(344),
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
