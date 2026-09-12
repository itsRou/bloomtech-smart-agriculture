import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';


class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  File? _image;
  String _result = "No result yet";
  String _cure = "";
  Uint8List? _modifiedImageBytes;

Future<void> _requestPermissions() async {
  if (Platform.isAndroid) {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }
  } else {
    if (await Permission.photos.isDenied) {
      await Permission.photos.request();
    }
  }
}


  Future<void> _pickImage() async {
  await _requestPermissions(); // 🛑 لازم دي الأول

  final pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      _image = File(pickedFile.path);
      _result = "Processing...";
      _cure = "";
      _modifiedImageBytes = null;
    });
    _uploadImage(_image!);
  }
}


  Future<void> _uploadImage(File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://192.168.120.229:5000/predict"),
    );

    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var jsonData = json.decode(responseData);

    setState(() {
      _result = jsonData['status'];
      _cure = jsonData.containsKey('cure') ? jsonData['cure'] : "";

      if (jsonData.containsKey('image')) {
        final base64String = jsonData['image'].split(',').last;
        _modifiedImageBytes = base64Decode(base64String);
      }
    });

    print("🔍 Prediction: ${jsonData['status']}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE9EDDE),
      body: SingleChildScrollView(
        // ✨ خليها Scrollable لو المساحة زادت
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // زر الرجوع والعنوان
            Row(
              children: [
                buildBigIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                        SizedBox(width: 16),
                Text(
                  'Scan',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF314D27),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // مربع الصورة
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: Color(0xFFDDE3D1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: _modifiedImageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.memory(_modifiedImageBytes!,
                              fit: BoxFit.cover),
                        )
                      : _image == null
                          ? Icon(
                              Icons.photo_camera,
                              color: Color(0xFF314D27),
                              size: 60,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(_image!, fit: BoxFit.cover),
                            ),
                ),
              ),
            ),
            SizedBox(height: 30),

            // ✅ عرض التشخيص والعلاج
            if (_result != "No result yet") ...[
              Card(
                color: Color(0xFFCBD5B4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.eco, color: Color(0xFF314D27), size: 35),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _result,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF314D27),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(Icons.local_hospital,
                              color: Color(0xFF314D27), size: 30),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _cure.isNotEmpty
                                  ? _cure
                                  : "No treatment information available.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF314D27),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],

            SizedBox(height: 50),

            // الدائرة في الأسفل
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFF7D9A66),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

   Widget buildBigIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/button_bg.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        icon: Icon(icon, size: 26),
        color: Color(0xff194E19),
        onPressed: onPressed,
      ),
    );
  }

}
