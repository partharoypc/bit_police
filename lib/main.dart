import 'dart:convert';

import 'package:bitpolice/utils/utilits.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

import 'app/config.dart';
import 'colors.dart';
import 'constants/strings.dart';
import 'home.dart';
import 'network/http_response.dart';
import 'shared/shared_prefs.dart';
import 'utils/util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MyColors.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// Progress dialog
  ProgressDialog _progressDialog;

  Image splashImage;

  Future<void> _loadDataForOffline(String url) async {
    try {
      final response = await http.get(url).timeout(Duration(seconds: 30));

      Http.printResponse(response);
      if (response.statusCode > 204 || response.body == null) {
        Util.showErrorToast();
      }

      var json = jsonDecode(response.body);
      // Save data to local storage
      utilities.storeData(url, json);
    } on Exception catch (_) {
      Util.showErrorToast();
    }
  }

  @override
  void initState() {
    super.initState();

    splashImage = Image.asset('assets/images/splash_logo.png', scale: 2.2);

    // Schedule a callback for the end of this frame.
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _checkNetworkConnection());
  }

  void _checkNetworkConnection() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    // Check for network only first launch
    if (result == ConnectivityResult.none && sharedPrefs.isFirstRun) {
      _showNetworkErrorDialog(context);
    } else {
      if (sharedPrefs.isFirstRun) {
        await _progressDialog.show();
        await _loadDataForOffline(Config.POLICE_HEADQUARTERS);
        await _loadDataForOffline(Config.CIRCLE);
        await _loadDataForOffline(Config.THANA);
        await _loadDataForOffline(Config.CONTROL_ROOM);
        await _loadDataForOffline(Config.CONTACT);
        await _loadDataForOffline(Config.ABOUT_US);
        await _progressDialog.hide();
        // Update the value to 'false' to prevent next time load data
        sharedPrefs.isFirstRun = false;
      }

      // After all operation close redirect to HomePage
      await Future.delayed(Duration(milliseconds: 1000));
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }
  }

  void _showNetworkErrorDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ইন্টারনেট সংযোগ নেই'),
          content: SingleChildScrollView(
            child: Text(
                'ইন্টারনেটের সাথে সংযোগ রাখতে আমাদের সমস্যা হচ্ছে। আপনার ইন্টারনেট সংযোগ পরীক্ষা করে দেখুন এবং আবার চেষ্টা করুন।'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('পুনরায় চেষ্টা করুন'),
              onPressed: () {
                Navigator.of(context).pop();
                _checkNetworkConnection(); // retry
              },
            ),
          ],
          contentPadding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(splashImage.image, context);
  }

  @override
  Widget build(BuildContext context) {
    // Init progress dialog
    _progressDialog = ProgressDialog(context, isDismissible: false);
    _progressDialog.style(
        message: "প্রথমবারের মতো ডাটা লোড করা হচ্ছে। অনুগ্রহ করে অপেক্ষা করুন...",
        messageTextStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400));

    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              appName,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 16)),
            Container(child: splashImage),
            const Padding(padding: EdgeInsets.only(bottom: 16)),
            const Text(
              appDesc,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 6)),
            const Text(
              address,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
