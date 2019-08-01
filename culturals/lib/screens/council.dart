import 'package:culturals/packages/cached_network_image.dart';
import 'package:flutter/material.dart';

class Council extends StatelessWidget {
  final List council;
  Council({Key key, @required this.council}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Council'),
      ),
      body: ListView.builder(
        itemCount: council.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(),
            margin: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: council[index]['photo_url'],
                  height: 140.0,
                  width: 140.0,
                  fit: BoxFit.cover,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                council[index]['name'].toString().toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.0),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                council[index]['post'],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.email, color: Colors.black, size: 16.0),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              council[index]['email'],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.phone, color: Colors.black, size: 16.0),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              council[index]['phone'],
                            ),
                          ),
                        ],
                      ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}