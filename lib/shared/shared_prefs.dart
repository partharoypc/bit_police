import 'dart:convert';

import 'package:bitpolice/constants/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _sharedPrefs;

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  List<dynamic> get spOfficeList =>
      jsonDecode(_sharedPrefs.getString(keySPOffice)) ?? [];

  set spOfficeList(List<dynamic> value) {
    _sharedPrefs.setString(keySPOffice, jsonEncode(value));
  }

  List<dynamic> get circleList =>
      jsonDecode(_sharedPrefs.getString(keyCircle)) ?? [];

  set circleList(List<dynamic> value) {
    _sharedPrefs.setString(keyCircle, jsonEncode(value));
  }

  List<dynamic> get policeStationList =>
      jsonDecode(_sharedPrefs.getString(keyPoliceStation)) ?? [];

  set policeStationList(List<dynamic> value) {
    _sharedPrefs.setString(keyPoliceStation, jsonEncode(value));
  }

  List<dynamic> get controlRoomList =>
      jsonDecode(_sharedPrefs.getString(keyControlRoom)) ?? [];

  set controlRoomList(List<dynamic> value) {
    _sharedPrefs.setString(keyControlRoom, jsonEncode(value));
  }

  List<dynamic> get contactList =>
      jsonDecode(_sharedPrefs.getString(keyContact)) ?? [];

  set contactList(List<dynamic> value) {
    _sharedPrefs.setString(keyContact, jsonEncode(value));
  }

  String get aboutUs =>
      _sharedPrefs.getString(keyAboutUs) ?? "";

  set aboutUs(String value) {
    _sharedPrefs.setString(keyAboutUs, value);
  }

  bool get isFirstRun => _sharedPrefs.getBool(keyIsFirstRun) ?? true;

  set isFirstRun(bool value) {
    _sharedPrefs.setBool(keyIsFirstRun, value);
  }
}

final sharedPrefs = SharedPrefs();
