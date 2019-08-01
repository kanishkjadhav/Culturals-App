import 'package:culturals/api.dart';
import 'package:culturals/packages/lazy_load_scrollview.dart';
import 'package:culturals/screens/sendnotification.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class NotificationScreen extends StatefulWidget {
  final bool admin;
  NotificationScreen({Key key, @required this.admin}) : super(key: key);
  @override
  _NotificationScreenState createState() => _NotificationScreenState(admin: admin);
}

class _NotificationScreenState extends State<NotificationScreen> {

  final bool admin;
  _NotificationScreenState({@required this.admin}) : super();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool loading;
  List<Notification> notifications;
  int requestCount;

  void initState() {
    loading = false;
    notifications = [];
    requestCount = 1;
    getNotifications(requestCount);
    super.initState();
  }

  void loadCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('notifications'));
    if (prefs.getString('notifications') != null)
      try {
        addNotifications(jsonDecode(prefs.getString('notifications')));
      } catch (ex) {}
    setState((){});
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Network error!!"),
      ],
    )));
  }

  void refresh() async {
    setState(() {
      loading = false;
      notifications = [];
      requestCount = 1;
    });
    getNotifications(requestCount);
  }

  void getNotifications(count) async {
    if (loading == true)
      return;
    print("Getting: " + requestCount.toString());
    setState(() {
      loading = true;
    });
    var response;
    try {
      response = (await http.get(notificationsURL + count.toString())).body;
    } catch (ex) {
      setState(() {
        requestCount++;
        loading = false;
      });
      if (count == 1)
        loadCache();
      return;
    }
    if (count == 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('notifications', response);
      notifications = [];
    }
    try {
      addNotifications(jsonDecode(response));
    } catch (ex) {
      if (count == 1)
        loadCache();
    }
    setState(() {
      requestCount++;
      loading = false;
    });
    print("Length: " + notifications.length.toString());
    print("Updated: " + requestCount.toString());
  }

  void addNotifications(List data) {
    for (int i = 0; i < data.length; i++) {
      String timestamp = data[i]["timestamp"];
      String title = data[i]["title"];
      String body = data[i]["body"];
      Notification notification = Notification(timestamp: timestamp, title: title, body: body);
      notifications.add(notification);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text('Notifications'),
          actions: <Widget>[
            IconButton(
              icon: new Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: refresh,
            ),
          ]
      ),
      body: (notifications.length == 0 && loading) ?
      // If Loading
      Center(
          child: CircularProgressIndicator()
      ) :
      // After Loading
      LazyLoadScrollView(
        onEndOfPage: () => getNotifications(requestCount),
        scrollOffset: 100,
        child: ListView.builder(
          itemCount: notifications.length + 1,
          itemBuilder: (context, index) {
            if (index == notifications.length && loading)
              return Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                child: Center(child: CircularProgressIndicator()),
              );
            else if (index == notifications.length && !loading)
              return SizedBox();
            else
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        notifications[index].title,
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2.5),
                      Text(notifications[index].body),
                      SizedBox(height: 2.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(notifications[index].timestamp),
                        ],
                      ),
                    ],
                  ),
                ),
              );
          },

        ),
      ),

      floatingActionButton: admin ? FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SendNotificationScreen()));
        },
        tooltip: 'Send Notification',
        child: Icon(Icons.add),
      ) : null,

    );
  }
}

class Notification {
  String timestamp;
  String title;
  String body;
  Notification({this.timestamp, this.title, this.body});
}
