import 'package:flutter/material.dart';
import '../Pages/sensors_pages/sensor_screen.dart';
import '../helper/dimintions.dart';
import '../widget/build_icon.dart';
import '../widget/user_planet_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserPlanetScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  const UserPlanetScreen({super.key, required this.setLocale});

  @override
  State<UserPlanetScreen> createState() => _UserPlanetScreenState();
}

class _UserPlanetScreenState extends State<UserPlanetScreen> {
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
      backgroundColor: Color(0xffE9EDDE),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: spacesWidth(21)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: spacesHeight(50),
              ),
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
              SizedBox(height: spacesHeight(15),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localization.numberOfMints,
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xff194E19),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  buildIconButton(Icons.search, () {}),
                ],
              ),
              SizedBox(
                height: spacesHeight(80),
              ),
              UserPlanetCard(
                name: localization.planetId,
                imagePath: 'assets/images/planet.png',
                id: '13244',
                onTap: () {
                   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SensorScreen(setLocale: widget.setLocale)),
                );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
