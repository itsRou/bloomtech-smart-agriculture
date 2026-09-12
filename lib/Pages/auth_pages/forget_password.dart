import 'package:flutter/material.dart';
import '../../widget/arrow_back.dart';
import '../../widget/leaf_image.dart';
import '../../widget/main_text.dart';
import '../../widget/mini_text.dart';
import '../../widget/myCustom_elevatedButton.dart';
import '../../widget/myCustom_textField.dart';
import '../../widget/myLoginIcons.dart';
import '../../widget/my_divider.dart';
import 'reset_password.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final Function(Locale) setLocale;

  const ForgotPasswordScreen({super.key, required this.setLocale});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
  final localization = AppLocalizations.of(context)!;

    print("Building ForgotPasswordScreen...");
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          print(
              "LayoutBuilder constraints: maxWidth = ${constraints.maxWidth}, maxHeight = ${constraints.maxHeight}");

          double iconSize = constraints.maxWidth * 0.13;
          double iconWidth = constraints.maxWidth * 0.12;
          return Stack(
            children: [
              leafImage(constraints: constraints),
              arrowBack(
                constraints: constraints, onPressed: () { Navigator.pop(context); },
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.05, // Reduce padding
                    vertical: constraints.maxHeight * 0.05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.25),
                      mainText(
                        constraints: constraints,
                        txt: localization.forgotPasswordTitle,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      miniText(
                          constraints: constraints,
                          txt:
                              localization.forgotPasswordSubtitle),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      customTextField(
                        hintTxt: localization.emailHint,
                        prefixIcon: Icon(Icons.email, color: Color(0xFF194E19)),
                        suffixIcon: Icon(Icons.check, color: Color(0xFF194E19)),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      customElevatedButton(
                        constraints: constraints,
                        txt: localization.recoverPassword,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetPassword(setLocale: widget.setLocale)));
                        },
                      ),
                      SizedBox(height: constraints.maxHeight * 0.08),
                      myDivider(
                        constraints: constraints,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      myLoginIcons(
                        iconWidth: iconWidth,
                        iconSize: iconSize,
                        constraints: constraints,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
