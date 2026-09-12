import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../helper/dimintions.dart';
import '../widget/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  const NotificationsScreen({super.key, required this.setLocale});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    // Retrieve screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListView(
              children: [
                SizedBox(height: spacesHeight(10)),
                Row(
                  children: [
                   InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFC3DEA9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xff194E19),
                  ),
                ),
              ),
                  ],
                ),
                SizedBox(height: constraints.maxHeight * 0.03),
                Text(
                  localization.notifications,
                  style: GoogleFonts.k2d(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF194E19),
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.03),
                NotificationCard(
                  title: 'Mint',
                  alertType: 'Water Alert',
                  message: 'Your Mint needs water',
                  imagePath:
                      'assets/images/planet.png', // Replace with your asset image path
                  timeAgo: '2 hours ago',
                ),
                NotificationCard(
                  title: 'Mint',
                  alertType: 'Light Update',
                  message: 'The Mint is getting too much light',
                  imagePath: 'assets/images/planet.png',
                  timeAgo: '5 hours ago',
                ),
                NotificationCard(
                  title: 'Thyme',
                  alertType: 'pH Alert',
                  message: 'Your pH level is low',
                  imagePath: 'assets/images/planet.png',
                  timeAgo: '8 hours ago',
                ),
                NotificationCard(
                  title: 'Basil',
                  alertType: 'Water Alert',
                  message: 'Your Basil needs water',
                  imagePath: 'assets/images/planet.png',
                  timeAgo: '1 day ago',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
