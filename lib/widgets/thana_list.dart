import 'dart:convert';

import 'package:bitpolice/app/config.dart';
import 'package:bitpolice/network/my_connectivity.dart';
import 'package:bitpolice/shared/shared_prefs.dart';
import 'package:bitpolice/utils/util.dart';
import 'package:bitpolice/utils/utilits.dart';
import 'package:bitpolice/widgets/thana_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ThanaList extends StatefulWidget {
  final String title;
  final Map data;
  final bool loading;

  ThanaList({Key key, @required this.title, this.data, this.loading = false})
      : super(key: key);

  @override
  _ThanaListState createState() => _ThanaListState();
}

class _ThanaListState extends State<ThanaList> {

  Future<List<dynamic>> _getPoliceStationList(String url) async {
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
    return json['thana'];
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
        child: widget.loading
            ? FutureBuilder(
                future: _getPoliceStationList(Config.THANA),
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
                        String title = items[index]['name'];
                        return singleListItemWidget(title, items[index], false);
                      },
                    );
                  }
                },
              )
            : CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      Map item = widget.data['station'][index];
                      return singleListItemWidget(item['name'], item['police'], true);
                    },
                    childCount: widget.data['station'].length,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      Map item = widget.data['union'][index];
                      List persons = item['person'];
                      // Sort List of Object (https://stackoverflow.com/a/64057685/5280371)
                      persons.sort((a, b) => a['category_id'].compareTo(b['category_id']));
                      return singleListItemWidget(item['name'], persons, true);
                    },
                    childCount: widget.data['union'].length,
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget singleListItemWidget(String title, dynamic data, bool showDetails) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Image.asset('assets/icons/right_arrow.png', scale: 1.3),
        onTap: () {
          if(showDetails) {
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => ThanaDetails(title: title, data: data)));
          } else {
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => ThanaList(title: title, data: data)));
          }
        },
      ),
    );
  }
}
