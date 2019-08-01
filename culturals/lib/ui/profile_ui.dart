import 'dart:convert';

import 'package:culturals/packages/cached_network_image.dart';
import 'package:culturals/screens/login.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {

  final Map profile;
  final bool my;
  final Function onEdit;
  Profile({Key key, @required this.profile, @required this.my, @required this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List achievements;
    int points;
    if (profile != null) {
      achievements = jsonDecode(profile['achievements']);
      points = achievements.map((achievement) {
        return achievement['points'];
      }).fold(0, (a, b) => a + b);
    }

    String intro;
    if (profile == null)
      intro = 'Login to view your profile';
    else if (profile['intro'] != null)
      intro = profile['intro'];
    else if (my)
      intro = 'Add an intro to your profile';
    else
      intro = null;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/cover_profile.jpg',
                        height: 120.0,
                        width: viewportConstraints.maxWidth,
                        fit: BoxFit.cover,
                      ),
                      Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.only(bottom: 4.0),
                        shape: RoundedRectangleBorder(),
                        child: SizedBox(
                          width: viewportConstraints.maxWidth,
                          child: Column(
                            children: <Widget>[

                              profile != null && my ?
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: Icon(Icons.edit, color: Colors.black),
                                    onPressed: onEdit,
                                  ),
                                ),
                              ) : SizedBox(height: 64.0),

                              SizedBox(height: 36.0),

                              Text(
                                profile!= null ? profile['name'] : 'Guest User',
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              profile != null && profile['nickname'].toString().length > 0 ? SizedBox(height: 4.0) : SizedBox(),
                              profile != null && profile['nickname'].toString().length > 0 ? Text(
                                '(' + profile['nickname'] + ')'
                              ) : SizedBox(),

                              profile != null ? SizedBox(height: 4.0) : SizedBox(),
                              profile != null ? Text(profile['rollno']) : SizedBox(),

                              intro != null ? SizedBox(height: 12.0) : SizedBox(),
                              intro != null ? Text(intro) : SizedBox(),

                              SizedBox(height: 12.0),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 45.0),
                    child: Center(
                      child: Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(75.0)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(73.0),
                            child: CachedNetworkImage(
                              imageUrl: (profile == null || profile["pic_url"] == null) ? "" : profile["pic_url"],
                              height: 146.0,
                              width: 146.0,
                              fit: BoxFit.cover,
                              placeholder: Padding(
                                padding: const EdgeInsets.all(55.0),
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: Padding(
                                padding: const EdgeInsets.all(55.0),
                                child: Icon(Icons.error_outline, size: 36.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              profile == null ?
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 24.0, 12.0, 12.0),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  padding: EdgeInsets.fromLTRB(64.0, 16.0, 64.0, 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('LOGIN'),
                    ],
                  ),
                  color: Colors.indigoAccent,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
                ),
              ) :

              Column(
                children: <Widget>[

                  Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.all(12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Text('HOSTEL'),
                                Text(
                                  profile['hostel'],
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          width: 1.0,
                          height: 48.0,
                          color: Colors.grey,
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Text('YEAR'),
                                Text(
                                  profile['year'],
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          width: 1.0,
                          height: 48.0,
                          color: Colors.grey,
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Text('CULT XP'),
                                Text(
                                  points.toString(),
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  !my ? SizedBox() :
                  Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.phone, color: Colors.black),
                              SizedBox(width: 18.0),
                              Text(profile['mobile']),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.email, color: Colors.black),
                              SizedBox(width: 18.0),
                              Text(profile['email']),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),

                  Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Clubs(profile: profile),
                    ),
                  ),

                  Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Clubs(profile: profile),
                    ),
                  )

                ],
              ),


            ],
          ),
        );
      },
    );
  }
}







class Clubs extends StatelessWidget {
  final Map profile;
  Clubs({Key key, @required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> columnChildren = [];
    columnChildren.add(
      Text(
        'CLUBS OF INTEREST',
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      )
    );
    columnChildren.add(
      SizedBox(height: 12.0)
    );
    List<String> clubs = [];
    if (profile['pixels'] == 'yes') clubs.add('Pixels');
    if (profile['rang'] == 'yes') clubs.add('Rang');
    if (profile['silverscreen'] == 'yes') clubs.add('Silverscreen');
    if (profile['symphony'] == 'yes') clubs.add('Symphony');
    if (profile['insync'] == 'yes') clubs.add('InSync');
    if (profile['fourthwall'] == 'yes') clubs.add('Fourthwall');
    if (profile['wespeak'] == 'yes') clubs.add('We Speak');
    if (profile['comedycons'] == 'yes') clubs.add('Comedy Cons');
    if (profile['vaani'] == 'yes') clubs.add('Vaani');
    if (profile['literati'] == 'yes') clubs.add('Literati');
    if (profile['roots'] == 'yes') clubs.add('Roots');
    if (profile['design'] == 'yes') clubs.add('Design');
    if (profile['lifestyle'] == 'yes') clubs.add('Lifestyle');

    if (clubs.length == 0) {
      columnChildren.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'No club selected :(',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        )
      );
    } else {
      while (clubs.length > 1) {
        columnChildren.add(
          Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0.0, 8.0, 8.0),
                    child: Text(clubs[0]),
                  )
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0.0, 8.0, 8.0),
                    child: Text(clubs[1]),
                  )
              ),
            ],
          )
        );
        clubs.remove(clubs[0]);
        clubs.remove(clubs[0]);
      }
      if (clubs.length == 1) {
        columnChildren.add(
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0.0, 8.0, 8.0),
                  child: Text(clubs[0]),
                )
              ),
            ],
          )
        );
      }
    }

    return Column(children: columnChildren);

  }


}