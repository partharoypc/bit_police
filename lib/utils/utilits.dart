import 'package:bitpolice/app/config.dart';
import 'package:bitpolice/shared/shared_prefs.dart';

class Utilities {

  void storeData(String url, var json) {
    switch (url) {
      case Config.POLICE_HEADQUARTERS:
        sharedPrefs.spOfficeList = json['spoffice'];
        break;
      case Config.CIRCLE:
        sharedPrefs.circleList = json['circle'];
        break;
      case Config.THANA:
        sharedPrefs.policeStationList = json['thana'];
        break;
      case Config.CONTROL_ROOM:
        sharedPrefs.controlRoomList = json['number'];
        break;
      case Config.CONTACT:
        sharedPrefs.contactList = json['contact'];
        break;
      case Config.ABOUT_US:
        sharedPrefs.aboutUs = json['about']['about'];
        break;
    }
  }

  List<dynamic> getData(String url) {
    switch (url) {
      case Config.POLICE_HEADQUARTERS:
        return sharedPrefs.spOfficeList;
      case Config.CIRCLE:
        return sharedPrefs.circleList;
      case Config.THANA:
        return sharedPrefs.policeStationList;
      case Config.CONTROL_ROOM:
        return sharedPrefs.controlRoomList;
      case Config.CONTACT:
        return sharedPrefs.contactList;
      default:
        return [];
    }
  }
}

var utilities = Utilities();
