import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';

class MyConnectivity {

  Future<bool> isOnline() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}

var network = MyConnectivity();
