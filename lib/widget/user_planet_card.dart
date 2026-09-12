import 'package:flutter/material.dart';


class UserPlanetCard extends StatelessWidget {
  final String name;
  final String id;
  final String imagePath;
  final VoidCallback onTap;

  const UserPlanetCard({
    Key? key,
    required this.name,
    required this.id,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 352,
        height: 98,
        
        decoration: BoxDecoration(
          color:  Color(0xFFEEF2E1),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset:  Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Row(
          
          children: [
            // Plant Info
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        color: Color(0xFF194E19),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                     SizedBox(height: 10),
                    Text(
                      id,
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 123, 116),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Plant Image
            Image(image: AssetImage(imagePath),)
          ],
        ),
      ),
    );
  }
}