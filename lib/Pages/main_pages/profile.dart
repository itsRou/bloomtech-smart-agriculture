import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../helper/dimintions.dart';

class Profile extends StatefulWidget {
  final Function(Locale) setLocale;
  const Profile({super.key, required this.setLocale});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

    return Container(
      height: double.infinity,
      width: double.infinity,
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/profile.png"),
        fit: BoxFit.fill,
      )),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: spacesHeight(30),
            ),
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile image.png"),
              radius: 75,
            ),
            // SizedBox(
            //   height: spacesHeight(3),
            // ),
            Text(
              "Kane",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xffE9EDDE)),
            ),
            SizedBox(
              height: spacesHeight(20),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacesWidth(52)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
              height: spacesHeight(45),
            ),
                  Text(
                    localization.email,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff194E19)),
                  ),
                  SizedBox(
                    height: spacesHeight(17),
                  ),
                  Text(
                    localization.password,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff194E19)),
                  ),
                  SizedBox(
                    height: spacesHeight(17),
                  ),
                  Text(
                    localization.phone,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff194E19)),
                  ),
                  SizedBox(
                    height: spacesHeight(100),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add logout functionality here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff40744D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                         localization.editProfile,
                          style:
                              TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: spacesHeight(22),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add logout functionality here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff40744D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          localization.changePassword,
                          style:
                              TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
