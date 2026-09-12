import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'LoginPage.dart';
import 'RoleSelectionPage.dart';


class HomePage extends StatefulWidget {
  final Function(Locale) setLocale;

  const HomePage({Key? key, required this.setLocale}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/splash.png',
            ), // Make sure the image path is correct
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
                  right:
                      MediaQuery.of(context).size.width *
                      0.2, // Reducing left padding further
                ),
                child: Text(
                  localization.homeTitle,
                  textAlign: TextAlign.left, // Text aligned to the left
                  style: TextStyle(
                    // fontFamily: 'K2D',
                    color: const Color.fromARGB(255, 25, 78, 25),
                    fontSize:
                        MediaQuery.of(context).size.width *
                        0.08, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.21,
              ), // Responsive spacing
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(
                    0.69,
                  ), // Applying 69% opacity to the background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.2,
                    vertical: MediaQuery.of(context).size.height * 0.012,
                  ), // Responsive button size
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage(setLocale: widget.setLocale)),
                  );
                },
                child: Text(
                  localization.signIn,
                  style: TextStyle(
                    //fontFamily: 'K2D', // Reference the custom font family
                    fontWeight: FontWeight.w600, // Semi-Bold weight (600)
                    color: const Color.fromARGB(
                      255,
                      25,
                      78,
                      25,
                    ), // Set text color as needed
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                  ),
                ),
              ),

              // Responsive spacing
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoleSelectionPage(setLocale: widget.setLocale),
                    ),
                  );
                },
                child: Text(
                   localization.createAccount,
                  style: TextStyle(
                    //fontFamily: 'K2D', // Reference the custom font family
                    fontWeight: FontWeight.w600, // Semi-Bold weight (600)
                    color: const Color.fromARGB(255, 25, 78, 25),
                    fontSize:
                        MediaQuery.of(context).size.width *
                        0.04, // Responsive font size
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
