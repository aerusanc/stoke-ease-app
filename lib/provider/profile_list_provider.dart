import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/model/model_profile.dart';

class ProfileProvider with ChangeNotifier {
  Profile? _profile;

  Profile? get profile => _profile;

  void setProfile(Profile newProfile) {
    _profile = newProfile;
    notifyListeners();
  }
  void updateProfile(Profile newProfile) {
    _profile = newProfile;
    notifyListeners(); // Memastikan bahwa widget yang mendengarkan perubahan mendapatkan pembaruan
  }
}
