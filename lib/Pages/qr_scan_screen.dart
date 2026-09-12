import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanScreen extends StatefulWidget {
  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan QR to Add Area")),
      body: MobileScanner(
        controller: MobileScannerController(
          facing: CameraFacing.back,
        ),
        onDetect: (BarcodeCapture capture) async {
          if (scanned) return;

          final barcode = capture.barcodes.first;
          final scannedText = barcode.rawValue;

          if (scannedText != null && scannedText.contains("mac:")) {
            scanned = true;

            final parts = scannedText.split(';');
            final areaName = parts[0].split(':')[1];
            final mac = parts[1].split(':')[1];

            await FirebaseDatabase.instance.ref('areas').push().set({
              'name': areaName,
              'mac': mac,
              'added_at': DateTime.now().toIso8601String(),
            }).then((_) {
              if (mounted) {
                // ⬅️ نرجع البيانات للصفحة اللي قبلها
                Navigator.pop(context, {
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'value': areaName,
                });
              }
            });
          }
        },
      ),
    );
  }
}
