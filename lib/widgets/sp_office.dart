import 'dart:convert';

import 'package:bitpolice/app/config.dart';
import 'package:bitpolice/network/my_connectivity.dart';
import 'package:bitpolice/utils/util.dart';
import 'package:bitpolice/utils/utilits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class SPOffice extends StatefulWidget {
  final String title;

  SPOffice({Key key, @required this.title}) : super(key: key);

  @override
  _SPOfficeState createState() => _SPOfficeState();
}

class _SPOfficeState extends State<SPOffice> {
  Future<List<dynamic>> _getOfficerList(String url) async {
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
    return json['spoffice'];
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
          future: _getOfficerList(Config.POLICE_HEADQUARTERS),
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
    String position = data['position'];
    String phone = data['phone'];
    String description = data['description'];
    String image = data['image'];

    return Card(
      child: Column(
        children: <Widget>[
          if (image != null) Center(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: Config.IMAGE_URL + image,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '$name, $position',
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                const Divider(color: Colors.black26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(phone),
                    InkWell(
                      customBorder: CircleBorder(),
                      child: Card(
                        elevation: 0.0,
                        color: Colors.blue[700],
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: const Icon(Icons.phone, color: Colors.white, size: 14),
                        )
                      ),
                      onTap: () => launch("tel:$phone"),
                    )
                  ],
                ),
                if (description != null) Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: HtmlWidget(description),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
