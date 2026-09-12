import 'package:flutter/material.dart';
import 'AdminRegisterationScreen.dart';
import 'UserRegisterationScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoleSelectionPage extends StatefulWidget {
  final Function(Locale) setLocale;
  const RoleSelectionPage({Key? key, required this.setLocale}) : super(key: key);

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
 
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/splash.png'), // Make sure the image path is correct
            fit: BoxFit.fill, // Ensures the background covers the entire screen
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width *
                      0.2, // Reducing left padding further
                ),
                child: Text(
                  localization.homeTitle,
                  textAlign: TextAlign.left, // Text aligned to the left
                  style: TextStyle(
                    //fontFamily: 'K2D',
                    color: const Color.fromARGB(255, 25, 78, 25),
                    fontSize: MediaQuery.of(context).size.width *
                        0.08, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.21), // Responsive spacing
              Container(
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.03), // Padding around the box
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.69), // Semi-transparent background
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Column(
                  children: [
                    // User Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal:
                             MediaQuery.of(context).size.width  * 0.24, // 30% horizontal padding
                          vertical: MediaQuery.of(context).size.height  * 0.01, // 3% vertical padding
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserRegisterationScreen(setLocale: widget.setLocale)),
                      );
                      },
                      child: Text(
                        localization.user,
                        style: TextStyle(
                          //fontFamily: 'K2D',
                          fontWeight: FontWeight.w600, // Semi-bold text
                          color: const Color.fromARGB(255, 25, 78, 25),
                          fontSize: MediaQuery.of(context).size.width * 0.048, // Font size 5% of screen width
                        ),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02), // Space between buttons

                    // Admin Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal:  MediaQuery.of(context).size.width * 0.22, // 30% horizontal padding
                          vertical:    MediaQuery.of(context).size.height * 0.01, // 3% vertical padding
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminRegistrationScreen(setLocale: widget.setLocale)),
                );
                      },
                      child: Text(
                        localization.admin,
                        style: TextStyle(
                          //fontFamily: 'K2D',
                          fontWeight: FontWeight.w600, // Semi-bold text
                          color: const Color.fromARGB(255, 25, 78, 25),
                          fontSize: MediaQuery.of(context).size.width *  0.048, // Font size 5% of screen width
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
