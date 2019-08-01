import 'package:culturals/packages/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:culturals/screens/home/events.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';


class EventScreen extends StatelessWidget {
  final Event event;
  EventScreen({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 180.0,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: event.imageURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(event.date, style: TextStyle(fontSize: 16.0)),
                      Text(event.day, style: TextStyle(fontSize: 16.0)),
                      Text(event.time, style: TextStyle(fontSize: 16.0)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                    child: Container(
                      height: 60.0,
                      width: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(event.name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                        Text(event.venue, style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Linkify(
                onOpen: (url) async {
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    print('Could not launch $url');
                  }
                },
                text: event.description,
                style: TextStyle(fontSize: 15.0),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(event.contact, style: TextStyle(fontSize: 15.0))
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Card(
                  elevation: 0.0,
                  color: Colors.grey[400],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(Icons.close),
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}