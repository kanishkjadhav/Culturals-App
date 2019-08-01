import 'dart:convert';
import 'package:culturals/api.dart';
import 'package:culturals/screens/council.dart';
import 'package:culturals/screens/genre.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;


class HomeInfo extends StatefulWidget {
  @override
  _HomeInfoState createState() => _HomeInfoState();

}

class _HomeInfoState extends State<HomeInfo> {

  Map info = {};

  @override
  void initState() {
    getInfo();
    updateInfo();
    super.initState();
  }

  getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('info') != null) {
      info = jsonDecode(prefs.getString('info'));
    } else {
      info = jsonDecode(await rootBundle.loadString('assets/info.json'));
    }
    setState(() {});
  }

  updateInfo() async {
    var response = await http.get(infoURL);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      prefs.setString('info', jsonEncode(jsonDecode(response.body)));
      getInfo();
    } catch (ex) {}
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/logo_icc.png',
                  height: 120.0,
                  width: 120.0,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'CULTURALS',
                      style: TextStyle(
                        fontSize: 26.0,
                        fontFamily: 'Femoralis'
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.0)
              ],
            ),

            SizedBox(height: 18.0),

            Text(
              info['intro'] ?? '',
              style: TextStyle(fontSize: 15.0),
            ),

            SizedBox(height: 32.0),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Genre(
                          name: 'Dance',
                          name1: 'Insync',
                          club1: info['insync1'],
                        )));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.asset('assets/images/mascot_background.png', height: 90.0, width: 90.0),
                            Image.asset('assets/images/mascot_dance.png', height: 90.0, width: 90.0)
                          ],
                        ),
                      ),
                    ),
                    Container(width: 90.0, child: Center(child: Text('Dance', textAlign: TextAlign.center))),
                  ],
                ),
                Expanded(child: SizedBox()),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Genre(
                          name: 'Dramatics',
                          name1: 'Fourthwall',
                          club1: info['fourthwall1'],
                        )));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.asset('assets/images/mascot_background.png', height: 90.0, width: 90.0),
                            Image.asset('assets/images/mascot_dram.png', height: 90.0, width: 90.0)
                          ],
                        ),
                      ),
                    ),
                    Container(width: 90.0, child: Center(child: Text('Dramatics', textAlign: TextAlign.center))),
                  ],
                ),
                Expanded(child: SizedBox()),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Genre(
                          name: 'Film and Media',
                          name1: 'SilverScreen',
                          club1: info['silverscreen1'],
                          name2: 'IIT BBC',
                          club2: info['iitbbc1'],
                        )));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.asset('assets/images/mascot_background.png', height: 90.0, width: 90.0),
                            Image.asset('assets/images/mascot_fnm.png', height: 90.0, width: 90.0)
                          ],
                        ),
                      ),
                    ),
                    Container(width: 90.0, child: Center(child: Text('Film and Media', textAlign: TextAlign.center))),
                  ],
                ),
              ],
            ),

            SizedBox(height: 18.0),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Genre(
                          name: 'Literary Arts',
                          name1: 'Literati',
                          club1: info['literati1'],
                        )));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.asset('assets/images/mascot_background.png', height: 90.0, width: 90.0),
                            Image.asset('assets/images/mascot_lit.png', height: 90.0, width: 90.0)
                          ],
                        ),
                      ),
                    ),
                    Container(width: 90.0, child: Center(child: Text('Literary Arts', textAlign: TextAlign.center))),
                  ],
                ),
                Expanded(child: SizedBox()),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Genre(
                          name: 'Music',
                          name1: 'Symphony',
                          club1: info['symphony1'],
                        )));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.asset('assets/images/mascot_background.png', height: 90.0, width: 90.0),
                            Image.asset('assets/images/mascot_music.png', height: 90.0, width: 90.0)
                          ],
                        ),
                      ),
                    ),
                    Container(width: 90.0, child: Center(child: Text('Music', textAlign: TextAlign.center))),
                  ],
                ),
                Expanded(child: SizedBox()),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Genre(
                          name: 'Photography and Fine Arts',
                          name1: 'Pixels',
                          club1: info['pixels1'],
                          name2: 'Rang',
                          club2: info['rang1'],
                        )));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.asset('assets/images/mascot_background.png', height: 90.0, width: 90.0),
                            Image.asset('assets/images/mascot_pfa.png', height: 90.0, width: 90.0)
                          ],
                        ),
                      ),
                    ),
                    Container(width: 90.0, child: Center(child: Text('Photography and Fine Arts', textAlign: TextAlign.center))),
                  ],
                ),
              ],
            ),

            SizedBox(height: 18.0),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Genre(
                          name: 'Classical and Folk Arts',
                          name1: 'Roots',
                          club1: info['roots1'],
                        )));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.asset('assets/images/mascot_background.png', height: 90.0, width: 90.0),
                            Image.asset('assets/images/mascot_cfa.png', height: 90.0, width: 90.0)
                          ],
                        ),
                      ),
                    ),
                    Container(width: 90.0, child: Center(child: Text('Classical and Folk Arts', textAlign: TextAlign.center))),
                  ],
                ),
                Expanded(child: SizedBox()),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Genre(
                          name: 'Indian Languages',
                          name1: 'Vaani',
                          club1: info['vaani1'],
                        )));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.asset('assets/images/mascot_background.png', height: 90.0, width: 90.0),
                            Image.asset('assets/images/mascot_il.png', height: 90.0, width: 90.0)
                          ],
                        ),
                      ),
                    ),
                    Container(width: 90.0, child: Center(child: Text('Indian Languages', textAlign: TextAlign.center))),
                  ],
                ),
                Expanded(child: SizedBox()),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Genre(
                          name: 'Speaking Arts',
                          name1: 'We Speak',
                          club1: info['wespeak1'],
                          name2: 'Comedy Cons',
                          club2: info['comedycons1'],
                        )));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.asset('assets/images/mascot_background.png', height: 90.0, width: 90.0),
                            Image.asset('assets/images/mascot_sa.png', height: 90.0, width: 90.0)
                          ],
                        ),
                      ),
                    ),
                    Container(width: 90.0, child: Center(child: Text('Speaking Arts', textAlign: TextAlign.center))),
                  ],
                ),
              ],
            ),

            SizedBox(height: 18.0),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: SizedBox()),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Genre(
                          name: 'Lifestyle',
                          name1: 'Lifestyle',
                          club1: info['lifestyle1'],
                        )));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.asset('assets/images/mascot_background.png', height: 90.0, width: 90.0),
                            Image.asset('assets/images/mascot_lifestyle.png', height: 90.0, width: 90.0)
                          ],
                        ),
                      ),
                    ),
                    Container(width: 90.0, child: Center(child: Text('Lifestyle', textAlign: TextAlign.center))),
                  ],
                ),
                Expanded(child: SizedBox()),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Genre(
                          name: 'Design',
                          name1: 'Design',
                          club1: info['design1'],
                        )));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.asset('assets/images/mascot_background.png', height: 90.0, width: 90.0),
                            Image.asset('assets/images/mascot_design.png', height: 90.0, width: 90.0)
                          ],
                        ),
                      ),
                    ),
                    Container(width: 90.0, child: Center(child: Text('Design', textAlign: TextAlign.center))),
                  ],
                ),
                Expanded(child: SizedBox()),
              ],
            ),

            SizedBox(height: 32.0),

            RaisedButton(
              onPressed: () async {
                const url = 'https://gymkhana.iitb.ac.in/~cultural/pg-cult/';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              padding: EdgeInsets.fromLTRB(64.0, 16.0, 64.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('PG CULT'),
                ],
              ),
              color: Colors.indigoAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
            ),

            SizedBox(height: 12.0),

            RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Council(council: info['council'])));
              },
              padding: EdgeInsets.fromLTRB(64.0, 16.0, 64.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('COUNCIL DETAILS'),
                ],
              ),
              color: Colors.indigoAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
            ),

          ],
        ),
      ),
    );
  }

}