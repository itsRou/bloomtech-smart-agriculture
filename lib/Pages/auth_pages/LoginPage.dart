import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../admin_provider.dart';
import '../auth_pages/AdminRegisterationScreen.dart';
import '../../helper/dimintions.dart';
import '../main_pages/main_admin_nav_screen.dart';
import '../main_pages/main_user_nav_screen.dart';
import 'UserRegisterationScreen.dart';
import 'forget_password.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  final Function(Locale) setLocale;

  const LoginPage({super.key, required this.setLocale});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool showUser = true;

  Color userBottomColor = Color(0xFF194E19);
  Color adminButtonColor = Color(0xffF3F3F3);
  Color userTextColor = Color(0xffFFFFFF);
  Color adminTextColor = Color(0xff1e1e1e);
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userPasswordController = TextEditingController();
  final TextEditingController adminEmailController = TextEditingController();
  final TextEditingController adminPasswordController = TextEditingController();

  @override
  void dispose() {
    userEmailController.dispose();
    userPasswordController.dispose();
    adminEmailController.dispose();
    adminPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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

    final paddingWidth = (24 / widthRatio) * width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: screenHeight, // Make container height responsive
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login.png'), // Add your image path
            fit: BoxFit.cover,
            // Cover the whole background responsively
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: spacesHeight(30),
                    horizontal: screenWidth *
                        0.05), // Move back button slightly to the right
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              SizedBox(height: spacesHeight(275)),
              //SizedBox(height: spacesHeight(100)),
              // Adjusted height
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacesWidth(60)),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          //title = local.offers;
                          userBottomColor = Color(0xFF194E19);
                          adminButtonColor = Color(0xffF3F3F3);
                          userTextColor = Color(0xffFFFFFF);
                          adminTextColor = Color(0xff1e1e1e);
                          showUser = true;
                        });
                      },
                      child: Container(
                        width: spacesWidth(156),
                        height: spacesHeight(33),
                        decoration: ShapeDecoration(
                          color: userBottomColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)),
                        ),
                        child: Center(
                          child: Text(
                            localization.user,
                            style: TextStyle(
                              color: userTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          //title = local.discounts;
                          adminButtonColor = Color(0xFF194E19);
                          userBottomColor = Color(0xffF3F3F3);
                          adminTextColor = Color(0xffFFFFFF);
                          userTextColor = Color(0xff1e1e1e);
                          showUser = false;
                        });
                      },
                      child: Container(
                        width: spacesWidth(156),
                        height: spacesHeight(33),
                        decoration: ShapeDecoration(
                          color: adminButtonColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)),
                        ),
                        child: Center(
                          child: Text(
                            localization.admin,
                            style: TextStyle(
                              color: adminTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: spacesHeight(20),
              ),
              Visibility(
                  visible: showUser,
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              localization.welcomeBack,
                              style: TextStyle(
                                //fontFamily: 'K2D',
                                color: const Color.fromARGB(255, 25, 78, 25),
                                fontSize:
                                    screenWidth * 0.08, // Adjusted font size
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              localization.loginToAccount,
                              style: TextStyle(
                                //fontFamily: 'K2D',
                                color: Colors.grey,
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05), // Adjusted height
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.1), // Adjusted padding
                        child: Column(
                          children: [
                            TextField(
                              controller: userEmailController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person,
                                    color: Color(0xFF194E19)),
                                hintText: localization.emailHint,
                                filled: true,
                                fillColor: Color.fromARGB(255, 218, 229, 221),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            SizedBox(
                                height: screenHeight * 0.03), // Adjusted height
                            TextField(
                              controller: userPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock,
                                    color: Color.fromARGB(255, 25, 78, 25)),
                                suffixIcon: const Icon(Icons.visibility,
                                    color: Color.fromARGB(255, 25, 78, 25)),
                                hintText: localization.password,
                                filled: true,
                                fillColor: Color.fromARGB(255, 218, 229, 221),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            SizedBox(
                                height: screenHeight * 0.01), // Adjusted height
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Transform.scale(
                                      scale: 1,
                                      child: Checkbox(
                                        value: true,
                                        onChanged: (value) {},
                                        shape: const CircleBorder(),
                                        activeColor: Color.fromARGB(
                                            255, 25, 78, 25), // ARGB color
                                      ),
                                    ),
                                     Text(
                                      localization.rememberMe,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          //fontFamily: 'K2D',
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPasswordScreen(setLocale: widget.setLocale)));
                                  },
                                  child: Text(
                                    localization.forgotPassword,
                                    style: TextStyle(
                                      //fontFamily: 'K2D',
                                      color:
                                          const Color.fromARGB(255, 25, 78, 25),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: screenHeight *
                                    0.06), // Adjusted height// Adjusted height
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 64, 116, 77),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 70,
                                    vertical: 10), // Adjusted padding
                              ),
                              onPressed: () {
                                // Login Logic
                                //signin(emailController, passwordController);
                                signInUser(userEmailController.text,
                                    userPasswordController.text);
                              },
                              child: Text(localization.login,
                                  style: TextStyle(
                                      //fontFamily: 'K2D',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18)), // Adjusted font size
                            ),
                            SizedBox(
                                height: screenHeight * 0.01), // Adjusted height
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   Text(
                                    localization.dontHaveAccount,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        //fontFamily: 'K2D',
                                        fontSize: 14),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UserRegisterationScreen(setLocale: widget.setLocale)));
                                    },
                                    child: Text(
                                      localization.signup,
                                      style: TextStyle(
                                        // fontFamily: 'K2D',
                                        color: Color.fromARGB(255, 25, 78, 25),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              Visibility(
                  visible: showUser == false,
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                             localization.welcomeBack,
                              style: TextStyle(
                                //fontFamily: 'K2D',
                                color: const Color.fromARGB(255, 25, 78, 25),
                                fontSize:
                                    screenWidth * 0.08, // Adjusted font size
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              localization.loginToAccount,
                              style: TextStyle(
                                //fontFamily: 'K2D',
                                color: Colors.grey,
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05), // Adjusted height
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.1), // Adjusted padding
                        child: Column(
                          children: [
                            TextField(
                              controller: adminEmailController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person,
                                    color: Color(0xFF194E19)),
                                hintText: localization.emailHint,
                                filled: true,
                                fillColor: Color.fromARGB(255, 218, 229, 221),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            SizedBox(
                                height: screenHeight * 0.03), // Adjusted height
                            TextField(
                              controller: adminPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock,
                                    color: Color.fromARGB(255, 25, 78, 25)),
                                suffixIcon: const Icon(Icons.visibility,
                                    color: Color.fromARGB(255, 25, 78, 25)),
                                hintText: localization.adminPassword,
                                filled: true,
                                fillColor: Color.fromARGB(255, 218, 229, 221),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            SizedBox(
                                height: screenHeight * 0.01), // Adjusted height
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Transform.scale(
                                      scale: 1,
                                      child: Checkbox(
                                        value: true,
                                        onChanged: (value) {},
                                        shape: const CircleBorder(),
                                        activeColor: Color.fromARGB(
                                            255, 25, 78, 25), // ARGB color
                                      ),
                                    ),
                                     Text(
                                     localization.rememberMe,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          //fontFamily: 'K2D',
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPasswordScreen(setLocale: widget.setLocale)));
                                  },
                                  child: Text(
                                    localization.forgotPassword,
                                    style: TextStyle(
                                      //fontFamily: 'K2D',
                                      color:
                                          const Color.fromARGB(255, 25, 78, 25),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: screenHeight *
                                    0.06), // Adjusted height// Adjusted height
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 64, 116, 77),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 70,
                                    vertical: 10), // Adjusted padding
                              ),
                              onPressed: () {
                                // Login Logic
                                signInAdmin(adminEmailController.text,
                                    adminPasswordController.text);
                              },
                              child: Text(localization.login,
                                  style: TextStyle(
                                      //fontFamily: 'K2D',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18)), // Adjusted font size
                            ),
                            SizedBox(
                                height: screenHeight * 0.01), // Adjusted height
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   Text(
                                    localization.dontHaveAccount,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        //fontFamily: 'K2D',
                                        fontSize: 14),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminRegistrationScreen(setLocale: widget.setLocale)));
                                    },
                                    child:  Text(
                                      localization.signup,
                                      style: TextStyle(
                                        // fontFamily: 'K2D',
                                        color: Color.fromARGB(255, 25, 78, 25),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> signin(emailAddress, password) async {
  //   FirebaseAuth.instance
  //       .signInWithEmailAndPassword(
  //     email: emailAddress.text,
  //     password: password.text,
  //   )
  //       .then((credential) {
  //     // Navigate to the HomeScreen if sign-in is successful
  //     Navigator.push(
  //       context,
  // MaterialPageRoute(
  //   builder: (context) =>
  //       MainNavigationBarScreen(), // Navigate to Dashboard
  // ),
  //     );
  //   }).catchError((error) {
  //     // Check if the error is of type FirebaseAuthException
  //     if (error is FirebaseAuthException) {
  //       if (error.code == 'user-not-found') {
  //         print('No user found for that email.');
  //       } else if (error.code == 'wrong-password') {
  //         print('Wrong password provided for that user.');
  //       } else {
  //         // Handle other Firebase authentication errors
  //         print('An error occurred: ${error.message}');
  //       }
  //     } else {
  //       // Handle any other errors
  //       print('An unexpected error occurred: $error');
  //     }
  //   });
  // }

  Future<void> signInAdmin(String email, String userPassword) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      // 1. Query the collection to find matching admin
      final querySnapshot = await db
          .collection("admins")
          .where("email", isEqualTo: email)
          .where("Adminpassword", isEqualTo: userPassword)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final adminData = querySnapshot.docs.first.data();
        final userId = adminData["id"];
        Provider.of<AdminProvider>(context, listen: false).setAdminId(userId);

        print("✅ Login successful. Admin ID: $userId");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainAdminNavScreen(setLocale: widget.setLocale)),
        );
      } else {
        print("❌ Invalid name or password.");
      }
    } catch (e) {
      print("❌ Error during login: $e");
    }
  }

  Future<void> signInUser(String email, String userPassword) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      // 1. Query the collection to find matching admin
      final querySnapshot = await db
          .collection("admins")
          .where("email", isEqualTo: email)
          .where("Userpassword", isEqualTo: userPassword)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final adminData = querySnapshot.docs.first.data();
        final userId = adminData["id"];
        Provider.of<AdminProvider>(context, listen: false).setAdminId(userId);

        print("✅ Login successful. Admin ID: $userId");

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainNavigationBarUserScreen(setLocale: widget.setLocale)),
        );
      } else {
        print("❌ Invalid name or password.");
      }
    } catch (e) {
      print("❌ Error during login: $e");
    }
  }
}
