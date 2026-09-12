import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../admin_provider.dart';
import '../main_pages/main_admin_nav_screen.dart';
import 'LoginPage.dart';

class AdminRegistrationScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  const AdminRegistrationScreen({Key? key, required this.setLocale}) : super(key: key);

  @override
  State<AdminRegistrationScreen> createState() =>
      _AdminRegistrationScreenState();
}

class _AdminRegistrationScreenState extends State<AdminRegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userpasswordController = TextEditingController();
  final TextEditingController adminpasswordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    userpasswordController.dispose();
    adminpasswordController.dispose();
    nameController.dispose();
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
            image: const AssetImage('assets/images/leaf.png'),
            fit: BoxFit.cover, // Ensures the image covers the entire screen
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
                  // Back Arrow Button
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // Title Section
                  Center(
                    child: Column(
                      children: [
                        Text(
                          localization.register,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 25, 78, 25),
                            // fontFamily: 'K2D',
                          ),
                        ),
                         Text(
                          localization.createNewAccount,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // Input Fields
                  _buildTextField(
                    controller: nameController,
                    icon: Icons.person,
                    hintText: localization.fullName,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildTextField(
                    controller: emailController,
                    icon: Icons.email,
                    hintText: localization.emailHint,
                    isEmail: true,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildTextField(
                    controller: userpasswordController,
                    icon: Icons.lock,
                    hintText: localization.userPassword,
                    isPassword: true,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildTextField(
                    controller: adminpasswordController,
                    icon: Icons.lock,
                    hintText:localization.adminPassword,
                    isPassword: true,
                  ),
                  SizedBox(height: screenHeight * 0.04),

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
                        //
                        createNestedData(nameController, emailController,
                            userpasswordController, adminpasswordController);
                      },
                      child:  Text(
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
                  // Remember Me Checkbox
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          shape: const CircleBorder(),
                          value: true,
                          onChanged: (value) {},
                          activeColor: const Color.fromARGB(255, 25, 78, 25),
                        ),
                      ),
                       Text(
                       localization.rememberMe,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // Divider and Social Media Section
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                        ),
                        child:  Text(localization.orContinueWith),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
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

                  // Login Redirect
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(
                         localization.alreadyHaveAccount,
                          style: TextStyle(color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage(setLocale: widget.setLocale)));
                          },
                          child:  Text(
                           localization.login,
                            style: TextStyle(
                              color: Color.fromARGB(255, 25, 78, 25),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 25, 78, 25)),
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFE8F5E9),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color.fromARGB(255, 25, 78, 25)),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return IconButton(
      icon: Icon(icon, color: color, size: 40),
      onPressed: () {
        // Handle social login action
      },
    );
  }

  Future<void> createNestedData(
    nameController, emailController, userpasswordController, adminpasswordController) async {
  // Reference to Firestore
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Generate a new document with an auto ID
  final docRef = db.collection("admins").doc();

  Map<String, dynamic> adminData = {
    "id": docRef.id, // 👈 Store the generated ID inside the document
    "name": nameController.text,
    "email": emailController.text,
    "Userpassword": userpasswordController.text,
    "Adminpassword": adminpasswordController.text,
    "timestamp": FieldValue.serverTimestamp(),
  };

  // Save data to Firestore
  await docRef.set(adminData);
  Provider.of<AdminProvider>(context, listen: false).setAdminId(docRef.id);

  print("✅ Admin created successfully with ID: ${docRef.id}");

  // Navigate to main screen
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MainAdminNavScreen(setLocale: widget.setLocale)),
  );
}

}
