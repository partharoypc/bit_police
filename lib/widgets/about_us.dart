import 'dart:convert';

import 'package:bitpolice/app/config.dart';
import 'package:bitpolice/network/my_connectivity.dart';
import 'package:bitpolice/shared/shared_prefs.dart';
import 'package:bitpolice/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;

class AboutUs extends StatefulWidget {
  final String title;

  AboutUs({Key key, @required this.title}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

  Future<String> _getData(String url) async {
    // load data from local storage
    bool isOnline = await network.isOnline();
    if (!isOnline) return sharedPrefs.aboutUs;

    final response = await http.get(url).timeout(Duration(seconds: 30));

    if (response.statusCode > 204 || response.body == null) {
      Util.showErrorToast();
      return "";
    }

    var json = jsonDecode(response.body);
    String about = json['about']['about'];
    // Store in local database
    sharedPrefs.aboutUs = about;
    return about;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        color: Colors.grey[100],
        child: FutureBuilder(
          future: _getData(Config.ABOUT_US),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.data.length == 0) {
              return Container(
                child: Center(
                  child: Text(
                    'No data available :(',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              );
            } else {
              String about = snapshot.data;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: HtmlWidget(about),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
