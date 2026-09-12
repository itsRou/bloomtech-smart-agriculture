import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../admin_provider.dart';

/// Writes real notification entries to Firestore under
/// admins/{adminId}/notifications, so the Notifications screen can show
/// live data instead of a static mockup.
class NotificationService {
  static Future<void> addAlert(
    BuildContext context, {
    required String title,
    required String alertType,
    required String message,
    String imagePath = 'assets/images/planet.png',
  }) async {
    final adminId =
        Provider.of<AdminProvider>(context, listen: false).adminId;
    if (adminId == null) return;

    await FirebaseFirestore.instance
        .collection('admins')
        .doc(adminId)
        .collection('notifications')
        .add({
      'title': title,
      'alertType': alertType,
      'message': message,
      'imagePath': imagePath,
      'timestamp': Timestamp.now(),
    });
  }
}
