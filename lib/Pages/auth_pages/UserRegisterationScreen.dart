import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../main_pages/main_user_nav_screen.dart';
import 'LoginPage.dart';

class UserRegisterationScreen extends StatefulWidget {
  final Function(Locale) setLocale;

  const UserRegisterationScreen({super.key, required this.setLocale});
  @override
  State<UserRegisterationScreen> createState() =>
      _UserRegisterationScreenState();
}

class _UserRegisterationScreenState extends State<UserRegisterationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/leaf.png'),
            fit: BoxFit.cover, // Ensure the image covers the entire screen
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back arrow
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color.fromARGB(255, 25, 78, 25),
                      size: 28,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.1), // Spacing
                  // Title and Subtitle
                  Center(
                    child: Column(
                      children: [
                        Text(
                          localization.register,
                          style: TextStyle(
                            //fontFamily: 'K2D',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 25, 78, 25),
                          ),
                        ),
                        Text(
                          localization.createNewAccount,
                          style: TextStyle(
                            //fontFamily: 'K2D',
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05), // Spacing
                  // Full Name Field
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 25, 78, 25),
                      ),
                      hintText: localization.fullName,
                      filled: true,
                      fillColor: Color.fromARGB(255, 218, 229, 221),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02), // Spacing
                  // Email Field
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Color.fromARGB(255, 25, 78, 25),
                      ),
                      hintText: localization.emailHint,
                      filled: true,
                      fillColor: Color.fromARGB(255, 218, 229, 221),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02), // Spacing
                  // Password Field
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color.fromARGB(255, 25, 78, 25),
                      ),
                      suffixIcon: const Icon(
                        Icons.visibility,
                        color: Color.fromARGB(255, 25, 78, 25),
                      ),
                      hintText: localization.password,
                      filled: true,
                      fillColor: Color.fromARGB(255, 218, 229, 221),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03), // Spacing
                  // Remember Me Checkbox

                  // Signup Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 64, 116, 77),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.01,
                        ),
                      ),
                      onPressed: () async {
                        // Signup Logic
                        await signup(emailController, passwordController);
                      },
                      child: Text(
                        localization.signup,
                        style: TextStyle(
                          fontSize: 20,
                          //fontFamily: 'K2D',
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1,
                        child: Checkbox(
                          value: true,
                          onChanged: (value) {},
                          shape: const CircleBorder(),
                          activeColor: Color.fromARGB(
                            255,
                            25,
                            78,
                            25,
                          ), // ARGB color
                        ),
                      ),
                      Text(
                        localization.rememberMe,
                        style: TextStyle(
                          color: Colors.grey, //fontFamily: 'K2D'
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03), // Spacing
                  // Spacing

                  // Social Media Login
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Color.fromARGB(255, 25, 78, 25),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                        ),
                        child: Text(
                          localization.orContinueWith,
                          style: TextStyle(
                            fontSize: 15,
                            //fontFamily: 'K2D',
                            color: Color.fromARGB(255, 25, 78, 25),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Color.fromARGB(255, 25, 78, 25),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02), // Spacing

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIcon(Icons.facebook, Colors.blue),
                      SizedBox(width: screenWidth * 0.05),
                      _buildSocialIcon(Icons.g_mobiledata, Colors.red),
                      SizedBox(width: screenWidth * 0.05),
                      _buildSocialIcon(Icons.apple, Colors.black),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03), // Spacing
                  // Login Text
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localization.alreadyHaveAccount,
                          style: TextStyle(
                            color: Colors.grey,
                            //fontFamily: 'K2D',
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        LoginPage(setLocale: widget.setLocale),
                              ),
                            );
                          },
                          child: Text(
                            localization.login,
                            style: TextStyle(
                              //fontFamily: 'K2D',
                              color: Color.fromARGB(255, 25, 78, 25),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02), // Bottom spacing
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signup(emailController, passwordController) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainNavigationBarUserScreen(setLocale: widget.setLocale)),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}

Widget _buildSocialIcon(IconData icon, Color color) {
  return IconButton(
    icon: Icon(icon, color: color, size: 40),
    onPressed: () {
      // Handle social login action
    },
  );
}
