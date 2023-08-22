import 'dart:convert';
import 'dart:developer';

import 'package:bitpolice/widgets/about_us.dart';
import 'package:bitpolice/widgets/circle_list.dart';
import 'package:bitpolice/widgets/contact.dart';
import 'package:bitpolice/widgets/control_room.dart';
import 'package:bitpolice/widgets/sp_office.dart';
import 'package:bitpolice/widgets/thana_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';

import 'app/config.dart';
import 'colors.dart';
import 'constants/strings.dart';

class HomeItems {
  String name;
  String icon;
  Color color;

  // constructor
  HomeItems(this.name, this.icon, this.color);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  /// time duration
  DateTime currentBackPressTime;

  /// default news
  String latestNews = "★★★ $districtNameর সকল বিটের দায়িত্বরত অফিসার ও ইউনিয়ন প্রতিনিধিদের নাম ও মোবাইল নম্বর সম্বলিত অ্যাপটি ব্যবহার করার জন্য ধন্যবাদ। ★★★";

  // all widget list
  List homeItems = [
    HomeItems("পুলিশ সুপারের কার্যালয়", 'assets/icons/ic_building.png', MyColors.teal),
    HomeItems("সার্কেল সমূহ", 'assets/icons/ic_police.png', MyColors.indigo),
    HomeItems("থানা সমূহ", 'assets/icons/ic_area.png', MyColors.violet),
    HomeItems("আমাদের সম্পর্কে", 'assets/icons/ic_about.png', MyColors.cyan),
    HomeItems("পুলিশ কন্ট্রোল রুম", 'assets/icons/ic_headphone.png', MyColors.pink),
    HomeItems("যোগাযোগ / হট লাইন", 'assets/icons/ic_help.png', MyColors.amber),
  ];

  Future<void> _getLatestNews() async {

    final response = await http.get(Config.NEWS).timeout(Duration(seconds: 30));
    log(response.body);

    if (response.statusCode > 204 || response.body == null) {
      return [];
    }

    Map json = jsonDecode(response.body);
    setState(() => latestNews = json['news']['news']);
  }

  @override
  void initState() {
    super.initState();
    /// request for latest news
    _getLatestNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Container(
          color: MyColors.primaryColor,
          padding: EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                districtName,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                appName,
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: ListView(
          children: <Widget>[
            GridView.count(
              crossAxisCount: 2,
              physics: ScrollPhysics(),
              // to disable GridView's scrolling
              shrinkWrap: true,
              padding: EdgeInsets.all(12.0),
              children: List<Widget>.generate(homeItems.length, (index) {
                return Card(
                  color: homeItems[index].color,
                  elevation: 0.0,
                  margin: EdgeInsets.all(6.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: InkWell(
                    //splashColor: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(homeItems[index].icon, scale: 2),
                        const Padding(padding: EdgeInsets.only(bottom: 12)),
                        Text(
                          homeItems[index].name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ) // text
                      ],
                    ),
                    onTap: () => _gotoDetailsPage(index),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 48.0,
        color: MyColors.primaryColor,
        child: Marquee(
          text: latestNews,
          style: TextStyle(color: Colors.white),
          blankSpace: 30.0,
          showFadingOnlyWhenScrolling: true,
          fadingEdgeStartFraction: 0.1,
          fadingEdgeEndFraction: 0.1,
          startPadding: 50.0,
        ),
      ),
    );
  }

  void _gotoDetailsPage(int index) {
    switch (index) {
      case 0:
        _navigate(SPOffice(title: homeItems[index].name));
        break;
      case 1:
        _navigate(CircleList(title: homeItems[index].name, loading: true));
        break;
      case 2:
        _navigate(ThanaList(title: homeItems[index].name, loading: true));
        break;
      case 3:
        _navigate(AboutUs(title: homeItems[index].name));
        break;
      case 4:
        _navigate(PoliceControlRoom(title: homeItems[index].name));
        break;
      case 5:
        _navigate(Contact(title: homeItems[index].name));
        break;
    }
  }

  void _navigate(Widget widget) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => widget));
  }

  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(milliseconds: 1500)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press back again to exit');
      return Future.value(false);
    }
    return Future.value(true);
  }
}
