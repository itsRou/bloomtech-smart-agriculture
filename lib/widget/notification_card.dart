import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/dimintions.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String alertType;
  final String message;
  final String imagePath;
  final String timeAgo;

  const NotificationCard({
    required this.title,
    required this.alertType,
    required this.message,
    required this.imagePath,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Plant name (title) above the card
        Padding(
          padding: EdgeInsets.only(bottom: screenWidth * 0.01),
          child: Text(
            title,
            style: GoogleFonts.k2d(
              fontSize: screenWidth * 0.07,
              fontWeight: FontWeight.bold,
              color: Color(0xFF40744D),
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.001),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: spacesWidth(15), vertical: spacesHeight(10)),
          child: Card(
            margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
            elevation: 0, // Disable default card elevation to use custom shadows
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: screenWidth *
                  0.9, // Adjust card width (90% of screen width, for example)
              height: screenWidth *
                  0.4, // Adjust card height (proportional to screen width)
              decoration: BoxDecoration(
                color: Color(0xFFEEF2E1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 0), // Shadow around the card
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alertType,
                            style: GoogleFonts.k2d(
                              color: Color(0xFF194E19),
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.01),
                          Text(
                            message,
                            
                            style: GoogleFonts.k2d(
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: screenWidth * 0.02),
                          Text(
                            timeAgo,
                            style: GoogleFonts.k2d(
                              fontSize: screenWidth * 0.035,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.35, // Larger image width
                      height: screenWidth * 0.5, // Larger image height
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain, // Ensures the image scales properly
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
