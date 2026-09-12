import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../helper/dimintions.dart';
import '../services_pages/services_page.dart';
import 'ph_level_sensor_screen.dart';
import 'soil_moisture_sensor_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SensorScreen extends StatefulWidget {
  const SensorScreen({super.key, required this.setLocale});
  final Function(Locale) setLocale;
  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  final DatabaseReference _moistureRef = FirebaseDatabase.instance.ref(
    "/soil_raw",
  );
  final DatabaseReference _pheRef = FirebaseDatabase.instance.ref("/ph_raw");
  final DatabaseReference _lightStatuseRef = FirebaseDatabase.instance.ref(
    "/ldr_raw",
  );
  final DatabaseReference _tempRef = FirebaseDatabase.instance.ref(
    "/temperature_raw",
  );
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    double spacesHeight(double number) {
      final height = MediaQuery.of(context).size.height;
      return (number / heightRatio) * height;
    }

    double spacesWidth(double number) {
      final width = MediaQuery.of(context).size.width;
      return (number / widthRatio) * width;
    }

    return Scaffold(
      backgroundColor: const Color(0xffE9EDDE),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: spacesWidth(15)),
          child: Column(
            children: [
              SizedBox(height: spacesHeight(50)),
              Row(
                children: [
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacesWidth(20)),
                    child: Text(
                      localization.sensorStatus,
                      style: TextStyle(
                        color: Color(0xff194E19),
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: spacesWidth(30),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ServicesPage(setLocale: (Locale ) {  },)),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFC3DEA9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cleaning_services_outlined,
                        color: Color(0xff194E19),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacesHeight(40)),
              Row(
                children: [
                  Column(
                    children: [
                      const Text(
                        "Soil Moisture",
                        style: TextStyle(
                          color: Color(0xff194E19),
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      StreamBuilder<DatabaseEvent>(
                        stream: _moistureRef.onValue,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.data == null ||
                              snapshot.data!.snapshot.value == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          double raw = double.tryParse(
                                snapshot.data!.snapshot.value.toString(),
                              ) ??
                              0;
                          double moisturePercent =
                              ((1023 - raw) / (1023 - 300)) * 100;
                          moisturePercent = moisturePercent.clamp(0, 100);

                          Color progressColor = getProgressColor(
                            moisturePercent,
                          );
                          Color backgroundColor = getBackgroundColor(
                            moisturePercent,
                          );

                          return TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 0.0,
                              end: moisturePercent / 100,
                            ),
                            duration: const Duration(milliseconds: 800),
                            builder: (context, value, child) {
                              return CircularPercentIndicator(
                                radius: 80,
                                lineWidth: 13.0,
                                animation: false,
                                percent: value.clamp(0.0, 1.0),
                                center: SvgPicture.asset(
                                  "assets/images/icon-drop.svg",
                                ),
                                footer: Text(
                                  "${(value * 100).toInt()}%",
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: progressColor,
                                  ),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: progressColor,
                                backgroundColor: backgroundColor,
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: spacesHeight(66)),
                      const Text(
                        "Temperature",
                        style: TextStyle(
                          color: Color(0xff194E19),
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      StreamBuilder<DatabaseEvent>(
                        stream: _tempRef.onValue,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.data == null ||
                              snapshot.data!.snapshot.value == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          double humidityPercent = double.tryParse(
                                snapshot.data!.snapshot.value.toString(),
                              ) ??
                              0;

                          return TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 0.0,
                              end: humidityPercent / 100,
                            ),
                            duration: const Duration(milliseconds: 800),
                            builder: (context, value, child) {
                              return CircularPercentIndicator(
                                radius: 80,
                                lineWidth: 13.0,
                                animation: false,
                                percent: value.clamp(0.0, 1.0),
                                center: SvgPicture.asset(
                                  "assets/images/carbon_temperature-hot.svg",
                                ),
                                footer: Text(
                                  "${(value * 100).toInt()}%",
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: Color(0xff194E19),
                                  ),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Color(0xff194E19),
                                backgroundColor: Color(0xffB6C9B3),
                              );
                            },
                          );
                        },
                      ),
                      // CircularPercentIndicator(
                      //   radius: 80,
                      //   lineWidth: 13.0,
                      //   animation: true,
                      //   percent: 0.42,
                      // center: SvgPicture.asset(
                      //     "assets/images/hugeicons_eco-power.svg"),
                      //   footer: const Text(
                      //     "42%",
                      //     style: TextStyle(
                      //       fontSize: 32,
                      //       color: Color(0xff355B34),
                      //     ),
                      //   ),
                      //   circularStrokeCap: CircularStrokeCap.round,
                      //   progressColor: const Color(0xff355B34),
                      //   backgroundColor: const Color(0xffB6C9B3),
                      // ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacesWidth(5)),
                    child: Column(
                      children: [
                        const Text(
                          "pH Level",
                          style: TextStyle(
                            color: Color(0xff194E19),
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        StreamBuilder<DatabaseEvent>(
                          stream: _pheRef.onValue,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData ||
                                snapshot.data == null ||
                                snapshot.data!.snapshot.value == null) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            double raw = double.tryParse(
                                  snapshot.data!.snapshot.value.toString(),
                                ) ??
                                0;
                            double pHPercent =
                                ((raw - 1.0) / (10.0 - 1.0)) * 100;
                            pHPercent = pHPercent.clamp(0, 100);

                            Color progressColor = getProgressColor(pHPercent);
                            Color backgroundColor =
                                getBackgroundColor(pHPercent);

                            return TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: 0.0,
                                end: pHPercent / 100,
                              ),
                              duration: const Duration(milliseconds: 800),
                              builder: (context, value, child) {
                                return CircularPercentIndicator(
                                  radius: 80,
                                  lineWidth: 13.0,
                                  animation: false,
                                  percent: value.clamp(0.0, 1.0),
                                  center: SvgPicture.asset(
                                    "assets/images/material-symbols_water-ph-outline-rounded.svg",
                                  ),
                                  footer: Text(
                                    "${(value * 100).toInt()}%",
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: progressColor,
                                    ),
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: progressColor,
                                  backgroundColor: backgroundColor,
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(height: spacesHeight(66)),
                        const Text(
                          "Light intensity",
                          style: TextStyle(
                            color: Color(0xff194E19),
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        StreamBuilder<DatabaseEvent>(
                          stream: _lightStatuseRef.onValue,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData ||
                                snapshot.data == null ||
                                snapshot.data!.snapshot.value == null) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            double raw = double.tryParse(
                                  snapshot.data!.snapshot.value.toString(),
                                ) ??
                                0;
                            double lightPercent =
                                ((850 - raw) / (850 - 50)) * 100;
                            lightPercent = lightPercent.clamp(0, 100);

                            Color progressColor =
                                getProgressColor(lightPercent);
                            Color backgroundColor = getBackgroundColor(
                              lightPercent,
                            );

                            return TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: 0.0,
                                end: lightPercent / 100,
                              ),
                              duration: const Duration(milliseconds: 800),
                              builder: (context, value, child) {
                                return CircularPercentIndicator(
                                  radius: 80,
                                  lineWidth: 13.0,
                                  animation: false,
                                  percent: value.clamp(0.0, 1.0),
                                  center: const Icon(
                                    Icons.wb_sunny_outlined,
                                    color: Color(0xffF0B89B),
                                    size: 55,
                                  ),
                                  footer: Text(
                                    "${(value * 100).toInt()}%",
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: progressColor,
                                    ),
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: progressColor,
                                  backgroundColor: backgroundColor,
                                );
                              },
                            );
                          },
                        ),
                        // CircularPercentIndicator(
                        //   radius: 80,
                        //   lineWidth: 13.0,
                        //   animation: true,
                        //   percent: 0.8,
                        // center: const Icon(
                        //   Icons.wb_sunny_outlined,
                        //   color: Color(0xffF0B89B),
                        //   size: 55,
                        // ),
                        //   footer: const Text(
                        //     "80%",
                        //     style: TextStyle(
                        //       fontSize: 32,
                        //       color: Color(0xff355B34),
                        //     ),
                        //   ),
                        //   circularStrokeCap: CircularStrokeCap.round,
                        //   progressColor: const Color(0xff355B34),
                        //   backgroundColor: const Color(0xffB6C9B3),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getProgressColor(double percent) {
    if (percent <= 30) {
      return const Color(0xffFF3D00); // Red for Dry
    } else {
      return const Color(0xff355B34); // Green for Moist/Wet
    }
  }

  Color getBackgroundColor(double percent) {
    if (percent <= 30) {
      return const Color(0xffF0B89B); // Beige for Dry background
    } else {
      return const Color(0xffB6C9B3); // Light green for Moist/Wet background
    }
  }
}
