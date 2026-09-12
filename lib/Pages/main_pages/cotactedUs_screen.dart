import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helper/dimintions.dart';

class AboutUsPage extends StatelessWidget {
  final Function(Locale) setLocale;
  const AboutUsPage({super.key, required this.setLocale});

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
          padding: EdgeInsets.symmetric(horizontal: spacesWidth(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: spacesHeight(60),
              ),
               InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFC3DEA9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color(0xff194E19),
                      ),
                    ),
                  ),
              SizedBox(
                height: spacesHeight(30),
              ),
             Padding(
               padding: EdgeInsets.symmetric(horizontal: spacesWidth(35)),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                  localization.aboutUs,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff194E19),
                  ),
                ),
                SizedBox(height: spacesHeight(35)),
                 Text(
                  localization.context1,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff194E19),
                  ),
                ),
                const SizedBox(height: 32),
                 Text(
                  localization.contactEmail,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff194E19),
                  ),
                ),
                const SizedBox(height: 32),
                 Text(
                  localization.follow,
                   style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff194E19),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    FaIcon(FontAwesomeIcons.facebook,
                        color: Color(0xff194E19), size: 30),
                    SizedBox(width: 20),
                    FaIcon(FontAwesomeIcons.instagram,
                        color: Color(0xff194E19), size: 30),
                    SizedBox(width: 20),
                    FaIcon(FontAwesomeIcons.twitter,
                        color: Color(0xff194E19), size: 30),
                  ],
                )
                ],
               ),
             )
            ],
          ),
        ),
      ),
    );
  }
}
