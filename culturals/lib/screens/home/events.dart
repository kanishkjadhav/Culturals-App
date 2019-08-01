import 'package:culturals/api.dart';
import 'package:culturals/packages/cached_network_image.dart';
import 'package:culturals/packages/lazy_load_scrollview.dart';
import 'package:culturals/screens/event.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class HomeEvents extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  HomeEvents({Key key, @required this.scaffoldKey}) : super(key: key);
  @override
  _HomeEventsState createState() => _HomeEventsState(scaffoldKey: scaffoldKey);
}

class _HomeEventsState extends State<HomeEvents> {

  final GlobalKey<ScaffoldState> scaffoldKey;
  _HomeEventsState({@required this.scaffoldKey}) : super();

  bool loading = false;
  bool error = false;
  bool past = false;
  List<Event> events = [];
  List<Event> pastEvents = [];
  int requestCount = 1;
  int pastRequestCount = 1;

  void initState() {
    loading = false;
    past = false;
    events = [];
    pastEvents = [];
    requestCount = 1;
    pastRequestCount = 1;
    getEvents(requestCount);
    super.initState();
  }

  void refresh() async {
    setState(() {
      loading = false;
      error = false;
      if (past) {
        pastEvents = [];
        pastRequestCount = 1;
      } else {
        events = [];
        requestCount = 1;
      }
    });
    if (past)
      getPastEvents(pastRequestCount);
    else
      getEvents(requestCount);
  }

  void getEvents(count) async {
    if (loading == true)
      return;
    print("Getting: " + requestCount.toString());
    setState(() {
      loading = true;
      error = false;
    });
    var response;
    try {
      response = (await http.get(eventsURL + count.toString())).body;
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
      prefs.setString('events', response);
      events = [];
    }
    try {
      addEvents(jsonDecode(response));
    } catch (ex) {
      if (count == 1)
        loadCache();
    }
    setState(() {
      requestCount++;
      loading = false;
    });
    print("Length: " + events.length.toString());
    print("Updated: " + requestCount.toString());
  }

  void getPastEvents(count) async {
    if (loading == true)
      return;
    print("GettingPast: " + pastRequestCount.toString());
    setState(() {
      loading = true;
      error = false;
    });
    var response;
    try {
      response = (await http.get(eventsPastURL + count.toString())).body;
    } catch (ex) {
      setState(() {
        pastRequestCount++;
        loading = false;
      });
      if (count == 1)
        loadPastCache();
      return;
    }
    if (count == 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('pastevents', response);
      pastEvents = [];
    }
    try {
      addPastEvents(jsonDecode(response));
    } catch (ex) {
      if (count == 1)
        loadPastCache();
    }
    setState(() {
      pastRequestCount++;
      loading = false;
    });
    print("LengthPast: " + events.length.toString());
    print("UpdatedPast: " + requestCount.toString());
  }

  void addEvents(List data) {
    for (int i = 0; i < data.length; i++) {
      Event event = Event(
        imageURL: data[i]["imageURL"],
        name: data[i]["name"],
        date: data[i]["date"],
        day: data[i]["day"],
        time: data[i]["time"],
        venue: data[i]["venue"],
        description: data[i]["description"],
        contact: data[i]["contact"],
      );
      events.add(event);
    }
  }

  void addPastEvents(List data) {
    for (int i = 0; i < data.length; i++) {
      Event event = Event(
        imageURL: data[i]["imageURL"],
        name: data[i]["name"],
        date: data[i]["date"],
        day: data[i]["day"],
        time: data[i]["time"],
        venue: data[i]["venue"],
        description: data[i]["description"],
        contact: data[i]["contact"],
      );
      pastEvents.add(event);
    }
  }

  void loadCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('events') != null)
      try {
        addEvents(jsonDecode(prefs.getString('events')));
      } catch (ex) {}
    error = true;
    setState((){});
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Network error!!"),
      ],
    )));

  }

  void loadPastCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('pastevents') != null)
      try {
        addPastEvents(jsonDecode(prefs.getString('pastevents')));
      } catch (ex) {}
    error = true;
    setState((){});
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Network error!!"),
      ],
    )));
  }

  @override
  Widget build(BuildContext context) {
    return LazyLoadScrollView(
      onEndOfPage: () {
        if (past)
          getPastEvents(pastRequestCount);
        else
          getEvents(requestCount);
      },
      scrollOffset: 100,
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        itemCount: (past ? pastEvents.length : events.length) + 2,
        itemBuilder: (context, index) {
          if (index == 0)
            return Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      onPressed: (){
                        if (past) {
                          past = false;
                          loading = false;
                          events = [];
                          pastEvents = [];
                          requestCount = 1;
                          pastRequestCount = 1;
                          getEvents(requestCount);
                        }
                      },
                      child: Text(
                        'UPCOMING',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: !past ? Colors.indigo : Colors.grey,
                          fontWeight: !past ? FontWeight.bold : FontWeight.normal
                        ),
                      )
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                        onPressed: () {
                          if (!past) {
                            past = true;
                            loading = false;
                            events = [];
                            pastEvents = [];
                            requestCount = 1;
                            pastRequestCount = 1;
                            getPastEvents(pastRequestCount);
                          }
                        },
                        child: Text(
                          'PAST',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: past ? Colors.indigo : Colors.grey,
                              fontWeight: past ? FontWeight.bold : FontWeight.normal
                          ),
                        )
                    ),
                  )
                ],
              ),
            );
          else if (index == (past ? pastEvents : events).length + 1 && loading)
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(child: CircularProgressIndicator()),
            );
          else if (index == (past ? pastEvents : events).length + 1 && !loading && error && index == 1)
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(child: Text('Network Error :(', style: TextStyle(fontStyle: FontStyle.italic))),
            );
          else if (index == (past ? pastEvents : events).length + 1 && !loading && index == 1)
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(child: Text('No Events Scheduled :(', style: TextStyle(fontStyle: FontStyle.italic))),
            );
          else if (index == (past ? pastEvents : events).length + 1 && !loading)
            return SizedBox();
          else
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EventScreen(event: (past ? pastEvents : events)[index-1])));
              },
              child: EventCard(event: (past ? pastEvents : events)[index-1])
            );
        },

      ),
    );
  }
}




class Event {
  String imageURL;
  String name;
  String date;
  String day;
  String time;
  String venue;
  String description;
  String contact;
  Event({this.imageURL, this.name, this.date, this.day, this.time, this.venue, this.description, this.contact});
}





class EventCard extends StatelessWidget {
  final Event event;
  EventCard({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(),
      margin: const EdgeInsets.fromLTRB(12.0, 2.0, 12.0, 12.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: event.imageURL,
                  height: 180.0,
                  fit: BoxFit.cover,
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
          )
        ],
      ),
    );
  }
}