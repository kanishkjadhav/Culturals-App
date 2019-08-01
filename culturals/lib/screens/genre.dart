import 'package:culturals/packages/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Genre extends StatelessWidget{
  final String name;
  final String name1;
  final Map club1;
  final String name2;
  final Map club2;
  Genre({Key key, @required this.name, @required this.name1, @required this.club1, this.name2, this.club2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CachedNetworkImage(
                    imageUrl: club1['logo'],
                    height: 240.0,
                    width: 240.0,
                  ),
                ),
              ),

              SizedBox(height: 12.0),

              Text(
                name1,
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.w500
                ),
              ),

              SizedBox(height: 12.0),

              Text(
                club1['description'],
                style: TextStyle(
                    fontSize: 15.0,
                ),
              ),

              SizedBox(height: 12.0),

              Row(
                children: <Widget>[
                  club1['fb1'] == "" ? SizedBox() :
                  GestureDetector(
                    onTap: () async {
                      var url = club1['fb1'];
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Card(
                      elevation: 0.0,
                      color: Colors.grey[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(FontAwesomeIcons.facebookF, color: Colors.black),
                      )
                    ),
                  ),
                  club1['fb2'] == "" ? SizedBox() :
                  GestureDetector(
                    onTap: () async {
                      var url = club1['fb2'];
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Card(
                        elevation: 0.0,
                        color: Colors.grey[300],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(FontAwesomeIcons.facebookF, color: Colors.black),
                        )
                    ),
                  ),
                  club1['youtube'] == "" ? SizedBox() :
                  GestureDetector(
                    onTap: () async {
                      var url = club1['youtube'];
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Card(
                        elevation: 0.0,
                        color: Colors.grey[300],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(FontAwesomeIcons.youtube, color: Colors.black),
                        )
                    ),
                  ),
                  club1['web'] == "" ? SizedBox() :
                  GestureDetector(
                    onTap: () async {
                      var url = club1['web'];
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Card(
                        elevation: 0.0,
                        color: Colors.grey[300],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(Icons.language, color: Colors.black),
                        )
                    ),
                  ),
                ],
              ),

              SizedBox(height: 36.0),

              club2 == null ? SizedBox() :
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CachedNetworkImage(
                    imageUrl: club2['logo'],
                    height: 240.0,
                    width: 240.0,
                  ),
                ),
              ),

              club2 == null ? SizedBox() :
              SizedBox(height: 12.0),

              club2 == null ? SizedBox() :
              Text(
                name2,
                style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w500
                ),
              ),

              club2 == null ? SizedBox() :
              SizedBox(height: 12.0),

              club2 == null ? SizedBox() :
              Text(
                club2['description'],
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),

              club2 == null ? SizedBox() :
              SizedBox(height: 12.0),

              club2 == null ? SizedBox() :
              Row(
                children: <Widget>[
                  club2['fb1'] == "" ? SizedBox() :
                  GestureDetector(
                    onTap: () async {
                      var url = club2['fb1'];
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Card(
                        elevation: 0.0,
                        color: Colors.grey[300],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(FontAwesomeIcons.facebookF, color: Colors.black),
                        )
                    ),
                  ),
                  club2['fb2'] == "" ? SizedBox() :
                  GestureDetector(
                    onTap: () async {
                      var url = club2['fb2'];
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Card(
                        elevation: 0.0,
                        color: Colors.grey[300],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(FontAwesomeIcons.facebookF, color: Colors.black),
                        )
                    ),
                  ),
                  club2['youtube'] == "" ? SizedBox() :
                  GestureDetector(
                    onTap: () async {
                      var url = club2['youtube'];
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Card(
                        elevation: 0.0,
                        color: Colors.grey[300],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(FontAwesomeIcons.youtube, color: Colors.black),
                        )
                    ),
                  ),
                  club2['web'] == "" ? SizedBox() :
                  GestureDetector(
                    onTap: () async {
                      var url = club2['web'];
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Card(
                        elevation: 0.0,
                        color: Colors.grey[300],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(Icons.language, color: Colors.black),
                        )
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

}