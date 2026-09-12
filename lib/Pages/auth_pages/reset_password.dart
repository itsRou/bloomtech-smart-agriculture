import 'package:flutter/material.dart';
import '../../widget/arrow_back.dart';
import '../../widget/leaf_image.dart';
import '../../widget/main_text.dart';
import '../../widget/mini_text.dart';
import '../../widget/myCustom_elevatedButton.dart';
import '../../widget/myCustom_textField.dart';
import '../../widget/myLoginIcons.dart';
import '../../widget/my_divider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPassword extends StatefulWidget {
  final Function(Locale) setLocale;
  const ResetPassword({super.key, required this.setLocale});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double iconSize = constraints.maxWidth * 0.13;
          double iconWidth = constraints.maxWidth * 0.12;

          return Stack(
            children: [
              leafImage(constraints: constraints),
              arrowBack(
                constraints: constraints,
                onPressed: () {
                  Navigator.pop(context);
                },
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
                      SizedBox(height: constraints.maxHeight * 0.26),
                      mainText(constraints: constraints, txt: localization.resetPasswordTitle),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      miniText(
                        constraints: constraints,
                        txt:
                           localization.resetPasswordSubtitle,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      customTextField(
                        hintTxt: localization.newPassword,
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF194E19)),
                        suffixIcon: Icon(
                          Icons.visibility,
                          color: Color(0xFF194E19),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      customTextField(
                        hintTxt: localization.confirmNewPassword,
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF194E19)),
                        suffixIcon: Icon(
                          Icons.visibility,
                          color: Color(0xFF194E19),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      customElevatedButton(
                        constraints: constraints,
                        txt: localization.recoverPassword,
                        onPressed: () {},
                      ),
                      SizedBox(height: constraints.maxHeight * 0.08),
                      myDivider(constraints: constraints),
                      SizedBox(height: constraints.maxHeight * 0.025),
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
