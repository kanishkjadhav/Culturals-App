import 'package:culturals/packages/cached_network_image.dart';
import 'package:culturals/screens/addevent.dart';
import 'package:culturals/screens/editprofile.dart';
import 'package:culturals/screens/home/info.dart';
import 'package:culturals/screens/login.dart';
import 'package:culturals/screens/notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:culturals/screens/home/events.dart';
import 'package:culturals/ui/profile_ui.dart';



class HomeScreen extends StatefulWidget {
  final Map profile;
  final int index;
  HomeScreen({Key key, @required this.profile, this.index}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState(profile: profile, index: index);
}

class _HomeScreenState extends State<HomeScreen> {

  Map profile;
  final int index;
  List<Map<String, Widget>> _children;
  _HomeScreenState({@required this.profile, this.index}) {
    _children = [
      {
        'title': Text('Events'),
        'body': HomeEvents(scaffoldKey: _scaffoldKey),
        'icon': Icon(Icons.date_range),
      },
      {
        'title': Text('Info'),
        'body': HomeInfo(),
        'icon': Icon(Icons.info),
      },
      {
        'title': Text('Rankings'),
        'body': Center(child: Text('Rankings')),
        'icon': Icon(Icons.card_giftcard),
      },
      {
        'title': Text('Profile'),
        'body': Profile(
          profile: profile,
          my: true,
          onEdit: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(profile: profile))).then((value) {
              updateProfile();
            });
          }
        ),
        'icon': Icon(Icons.person),
      },
    ];
  }

  static GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    if (index != null)
      _currentIndex = index;
    super.initState();
  }

  updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profile = jsonDecode(prefs.getString('profile'));
      _children[3]['body'] = Profile(
        profile: profile,
        my: true,
        onEdit: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(profile: profile))).then((value) {
            updateProfile();
          });
        }
      );
    });
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('profile');
    prefs.remove('username');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: _children[_currentIndex]['title'],
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.notifications),
            tooltip: 'Notifications',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen(admin: profile != null ? profile['admin_notify'] : false)));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                    ),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: CachedNetworkImage(
                            imageUrl: (profile != null) ? profile["pic_url"] : "",
                            height: 80.0,
                            width: 80.0,
                            fit: BoxFit.cover,
                            placeholder: Icon(Icons.person, size: 80.0),
                            errorWidget: Icon(Icons.person, size: 80.0),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: (profile != null) ?
                            <Widget>[
                              Text(profile["name"], style: TextStyle(fontSize: 16.0, color: Colors.white)),
                              SizedBox(height: 8.0),
                              Text(profile["rollno"], style: TextStyle(fontSize: 16.0, color: Colors.white)),
                            ] :
                            <Widget> [
                              Text("Guest", style: TextStyle(fontSize: 16.0, color: Colors.white)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.black),
                    title: Text((profile != null) ? 'Logout' : 'Login', style: TextStyle(fontSize: 16.0)),
                    onTap: () {
                      Navigator.pop(context);
                      logout();
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(FontAwesomeIcons.facebookF),
                  tooltip: 'Facebook',
                  onPressed: () async {
                    const url = 'http://fb.me/IITBCult';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.language),
                  tooltip: 'Website',
                  onPressed: () async {
                    const url = 'https://gymkhana.iitb.ac.in/~cultural/';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.indigo,
            primaryColor: Colors.white,
            textTheme: Theme.of(context).textTheme.copyWith(caption: TextStyle(color: Colors.grey[400]))),
        child: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          items: _children.map((child) =>
              BottomNavigationBarItem(
                icon: child['icon'],
                title: child['title'],
              )
          ).toList(),
          type: BottomNavigationBarType.fixed,
        ),
      ),
      body: _children[_currentIndex]['body'],
      floatingActionButton: (_currentIndex == 0 && profile != null && profile['admin_event']) ? FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddEventScreen(name: profile['name'], phone: profile['mobile'])));
        },
        tooltip: 'Add Event',
        child: Icon(Icons.add),
      ) : null,
    );
  }
}