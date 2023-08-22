
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ThanaDetails extends StatefulWidget {
  final String title;
  final List<dynamic> data;

  ThanaDetails({Key key, @required this.title, this.data})
      : super(key: key);

  @override
  _ThanaDetailsState createState() => _ThanaDetailsState();
}

class _ThanaDetailsState extends State<ThanaDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        color: Colors.grey[100],
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  Map item = widget.data[index];
                  return singleListItemWidget(item);
                },
                childCount: widget.data.length,
              ),
            ),
          ],
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
            style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.bold),
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
