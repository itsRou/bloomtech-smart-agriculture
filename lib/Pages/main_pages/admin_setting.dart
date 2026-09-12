import 'package:flutter/material.dart';
import '../../helper/dimintions.dart';
import '../auth_pages/LoginPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'cotactedUs_screen.dart';

class AdminSetting extends StatefulWidget {
  final Function(Locale) setLocale;
  const AdminSetting({super.key, required this.setLocale});

  @override
  State<AdminSetting> createState() => _AdminSettingState();
}

class _AdminSettingState extends State<AdminSetting> {

  bool enableNotifications = true;
  bool receiveWeeklyReports = false;
  bool automaticAction = false;

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
          padding: EdgeInsets.symmetric(horizontal: spacesWidth(39)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: spacesHeight(60),
              ),
              SizedBox(
                height: spacesHeight(30),
              ),
              Text(
                localization.settings,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff194E19),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: enableNotifications,
                          onChanged: (value) {
                            setState(() {
                              enableNotifications = value!;
                            });
                          },
                          activeColor: Color(0xff194E19),
                        ),
                        SizedBox(width: 8),
                        Text(
                          localization.enableNotifications,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff194E19),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AboutUsPage(setLocale: widget.setLocale)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff40744D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.phone, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              localization.contactUs,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //SizedBox(height: 16),
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //       value: receiveWeeklyReports,
                    //       onChanged: (value) {
                    //         setState(() {
                    //           receiveWeeklyReports = value!;
                    //         });
                    //       },
                    //       activeColor: Color(0xff194E19),
                    //     ),
                    //     SizedBox(width: 8),
                    //     Text(
                    //       localization.receiveWeeklyReports,
                    //       style: TextStyle(
                    //         fontSize: 15,
                    //         color: Color(0xff194E19),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //       value: automaticAction,
                    //       onChanged: (value) {
                    //         setState(() {
                    //           automaticAction = value!;
                    //         });
                    //       },
                    //       activeColor: Color(0xff194E19),
                    //     ),
                    //     SizedBox(width: 8),
                    //     Text(
                    //      localization.automaticAction,
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         color: Color(0xff194E19),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text(localization.changeLanguage),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        title: Text("العربية"),
                                        onTap: () {
                                          widget.setLocale(Locale('ar'));
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title: Text("English"),
                                        onTap: () {
                                          widget.setLocale(Locale('en'));
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff40744D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.language, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              localization.changeLanguage,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                 
                  ],
                ),
              ),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add logout functionality here
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage(setLocale: widget.setLocale)),
                      (Route<dynamic> route) =>
                          false, // remove all previous routes
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff40744D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.logout, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                       localization.logout,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacesHeight(81)),
            ],
          ),
        ),
      ),
    );
  }
}
