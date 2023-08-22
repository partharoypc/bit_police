import 'dart:convert';

import 'package:bitpolice/app/config.dart';
import 'package:bitpolice/network/my_connectivity.dart';
import 'package:bitpolice/shared/shared_prefs.dart';
import 'package:bitpolice/utils/util.dart';
import 'package:bitpolice/utils/utilits.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CircleList extends StatefulWidget {
  final String title;
  final Map data;
  final bool loading;

  CircleList({Key key, @required this.title, this.data, this.loading = false})
      : super(key: key);

  @override
  _CircleListState createState() => _CircleListState();
}

class _CircleListState extends State<CircleList> {

  Future<List<dynamic>> _getCircleList(String url) async {
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
    return json['circle'];
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
                future: _getCircleList(Config.CIRCLE),
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
                        return singleListItemWidget(title, items[index], true);
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
                      Map item = widget.data['thana'][index];
                      return singleListItemWidget(item['name'], Map(), false);
                    },
                    childCount: widget.data['thana'].length,
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget singleListItemWidget(String title, Map data, bool showNext) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: showNext ? Image.asset('assets/icons/right_arrow.png', scale: 1.3) : null,
        onTap: showNext ? () => _goNext(title, data) : null,
      ),
    );
  }

  _goNext(String title, dynamic data) {
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => CircleList(title: title, data: data)));
  }
}
