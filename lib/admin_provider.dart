import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  String? _adminId;

  String? get adminId => _adminId;

  void setAdminId(String id) {
    _adminId = id;
    notifyListeners();
  }

  void clearAdminId() {
    _adminId = null;
    notifyListeners();
  }
}
