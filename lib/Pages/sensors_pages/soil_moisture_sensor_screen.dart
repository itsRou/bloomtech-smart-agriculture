import 'package:flutter/material.dart';
import '../../helper/dimintions.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SoilMoistureSensorScreen extends StatefulWidget {
  const SoilMoistureSensorScreen({super.key});

  @override
  State<SoilMoistureSensorScreen> createState() =>
      _SoilMoistureSensorScreenState();
}

class _SoilMoistureSensorScreenState extends State<SoilMoistureSensorScreen> {
  @override
  Widget build(BuildContext context) {
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
      backgroundColor: const Color(0xffE9EDDE),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: spacesWidth(21)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: spacesHeight(50),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
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
                    padding: EdgeInsets.symmetric(horizontal: spacesWidth(14)),
                    child: Text(
                      "Soil Moisture Action ",
                      style: TextStyle(
                          color: Color(0xff194E19),
                          fontSize: 27,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
              SizedBox(height: spacesHeight(170)),
              Text(
                "Soil Moisture",
                style: TextStyle(
                    color: Color(0xff194E19),
                    fontSize: 26,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: spacesHeight(25),
              ),
              CircularPercentIndicator(
                  radius: 80,
                  lineWidth: 13.0,
                  animation: true,
                  percent: 0.3,
                  center: SvgPicture.asset("assets/images/icon-drop.svg"),
                  footer: Text(
                    "30%",
                    style: TextStyle(fontSize: 32, color: Color(0xffFF3D00)),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Color(0xffFF3D00),
                  backgroundColor: Color(0xffF0B89B)),
                  SizedBox(
                    height: spacesHeight(220),
                  ),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 53,
                  width: 299,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: Color(0xff97BA75)),
                  child: Center(
                      child: Text(
                    "ON",
                    style: TextStyle(
                        color: Color(0xffE9EDDE),
                        fontSize: 36,
                        fontWeight: FontWeight.w600),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
