import 'package:flutter/material.dart';
import '../../helper/dimintions.dart';
import '../../widget/text_field.dart';
import 'main_admin_nav_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddScreen extends StatefulWidget {
  final Function(Locale) setLocale;

  const AddScreen({super.key, required this.setLocale});
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  // القيمة المختارة حاليًا
  String? selectedPH;
  String? selectedSoil;
  final DatabaseReference _phStatusRef =
      FirebaseDatabase.instance.ref("/ph_statues");
  final DatabaseReference _soilMoistureRef =
      FirebaseDatabase.instance.ref("/soil_statues");
  final DatabaseReference _tempeRef =
      FirebaseDatabase.instance.ref("/temperature");
  TextEditingController tempController = TextEditingController();
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

    // الاختيارات
    final List<String> phOptions = ['Acidic', 'Alkaline', 'Neutral'];
    final List<String> soilOptions = ['Dry', 'Very Dry', 'Moderate Dry'];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffE9EDDE),
      body: SafeArea(
        child: Container(
            height: double.infinity,
            width: double.infinity,
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(
                "assets/images/add page.png",
              ),
              fit: BoxFit.cover,
            )),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacesWidth(40)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: spacesHeight(322),
                    ),
                    Row(
                      children: [
                        Text(
                          localization.plantName,
                          style: TextStyle(
                              color: Color(0xffE9EDDE),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: spacesWidth(14),
                        ),
                        CustomTextField()
                      ],
                    ),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: spacesHeight(14)),
                        child: Row(
                          children: [
                            Text(
                              localization.phStatus,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xffE9EDDE)),
                            ),
                            const SizedBox(width: 25),
                            Expanded(
                              child: Container(
                                width: 180,
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Color(0xffE9EDDE),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: selectedPH,
                                    hint: Text(
                                      localization.choosePhStatus,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.black, // علشان يظهر بوضوح
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    items: phOptions.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedPH = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                      localization.temperature,
                      style: TextStyle(
                          color: Color(0xffE9EDDE),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                     const SizedBox(width: 14),
                      Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color(0xffE9EDDE),
                              borderRadius: BorderRadius.circular(20)),
                          child: TextField(
                            controller: tempController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xffE9EDDE),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: spacesHeight(30),
                    // ),
                    // Row(
                    //   children: [
                    //     Text(
                    //       "Light \nintensity",
                    //       style: TextStyle(
                    //           color: Color(0xffE9EDDE),
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.bold),
                    //       textAlign: TextAlign.center,
                    //     ),
                    //     SizedBox(
                    //       width: spacesWidth(38),
                    //     ),
                    //     CustomTextField(
                    //       suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
                    //       iconColor: Color(0xff436E40),
                    //     )
                    //   ],
                    // ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacesHeight(14)),
                      child: Row(
                        children: [
                          Text(
                            localization.soilMoisture,
                            style: TextStyle(
                                color: Color(0xffE9EDDE),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Container(
                              width: 180,
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Color(0xffE9EDDE),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedSoil,
                                  style: const TextStyle(
                                    color: Colors.black, // علشان يظهر بوضوح
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  items: soilOptions.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedSoil = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: spacesHeight(220),
                    ),
                    InkWell(
                      onTap: () {
                        if (selectedSoil != null) {
                          _phStatusRef.set(selectedPH).then((_) {
                            print("✅ pH Status saved!");
                          }).catchError((e) {
                            print("❌ Firebase Error: $e");
                          });
                        }

                        _soilMoistureRef.set(selectedSoil).then((_) {
                          print("✅ Soil Moisture sent");
                        }).catchError((e) {
                          print("❌ Firebase Error: $e");
                        });

                        double temperature =
                            double.tryParse(tempController.text) ?? 0;

                        _tempeRef.set(temperature).then((_) {
                          print("✅ Temperature sent: $temperature °C");
                        }).catchError((error) {
                          print("❌ Failed to send temperature: $error");
                        });

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: const Color(0xffE9EDDE),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text(localization.addNewPlantTitle),
                              content: Text(localization.addNewPlantContent),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(localization.close,
                                      style:
                                          TextStyle(color: Color(0xff436E40))),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MainAdminNavScreen(
                                                setLocale: widget.setLocale),
                                      ),
                                    );
                                  },
                                  child: Text(localization.ok,
                                      style:
                                          TextStyle(color: Color(0xff436E40))),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Center(
                        child: Container(
                          width: 299,
                          height: 53,
                          decoration: BoxDecoration(
                              color: Color(0xffC3DEA9),
                              borderRadius: BorderRadius.circular(17)),
                          child: Center(
                              child: Text(
                            localization.add,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff436E40)),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
