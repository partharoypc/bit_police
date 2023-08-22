
import 'dart:convert';

import 'package:bitpolice/app/config.dart';
import 'package:bitpolice/network/my_connectivity.dart';
import 'package:bitpolice/shared/shared_prefs.dart';
import 'package:bitpolice/utils/util.dart';
import 'package:bitpolice/utils/utilits.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class PoliceControlRoom extends StatefulWidget {
  final String title;

  PoliceControlRoom({Key key, @required this.title}) : super(key: key);

  @override
  _PoliceControlRoomState createState() => _PoliceControlRoomState();
}

class _PoliceControlRoomState extends State<PoliceControlRoom> {

  Future<List<dynamic>> _getControlRoomList(String url) async {
    // load data from local storage
    bool isOnline = await network.isOnline();
    if (!isOnline) return utilities.getData(url);

    final response = await http.get(url).timeout(Duration(seconds: 30));

    if (response.statusCode > 204 || response.body == null) {
      Util.showErrorToast();
      return [];
    }

    var json = jsonDecode(response.body);
    utilities.storeData(url, json);
    return json['number'];
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
          future: _getControlRoomList(Config.CONTROL_ROOM),
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
              List items = snapshot.data;
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  Map item = items[index];
                  return singleListItemWidget(item);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget singleListItemWidget(Map data) {
    String name = data['name'];
    String designation = data['designation'];
    String phone = data['phone'];

    return Card(
      child: ListTile(
        title: RichText(
          text: TextSpan(
            text: name,
            style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(text: ' ($designation)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
        subtitle: Text(phone),
        trailing: InkWell(
          customBorder: CircleBorder(),
          child: Image.asset('assets/icons/ic_phone.png', scale: 1.2),
          onTap: () => launch("tel:$phone"),
        ),
      ),
    );
  }
}
