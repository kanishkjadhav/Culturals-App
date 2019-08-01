import 'dart:convert';
import 'dart:io';
import 'package:culturals/packages/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:culturals/api.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';



class EditProfileScreen extends StatefulWidget {

  final Map profile;
  EditProfileScreen({Key key, @required this.profile}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState(profile: profile);
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final Map profile;
  _EditProfileScreenState({@required this.profile}) : super();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final editFormKey = GlobalKey<FormState>();
  List<String> hostels = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15A", "15B", "15C", "16A", "16B", "16C", "Tansa"];
  List<String> years = ["1", "2", "3", "4", "5"];

  File dp;
  final nicknameController = TextEditingController();
  final introController = TextEditingController();
  String hostel;
  String year;
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  bool pixels;
  bool rang;
  bool silverscreen;
  bool symphony;
  bool insync;
  bool fourthwall;
  bool wespeak;
  bool comedycons;
  bool vaani;
  bool literati;
  bool roots;
  bool design;
  bool lifestyle;


  @override
  void initState() {
    nicknameController.text = profile['nickname'];
    introController.text = profile['intro'];
    hostel = profile['hostel'];
    year = profile['year'];
    phoneController.text = profile['mobile'];
    emailController.text = profile['email'];
    pixels = profile['pixels'] == 'yes';
    rang = profile['rang'] == 'yes';
    silverscreen = profile['silverscreen'] == 'yes';
    symphony = profile['symphony'] == 'yes';
    insync = profile['insync'] == 'yes';
    fourthwall = profile['fourthwall'] == 'yes';
    wespeak = profile['wespeak'] == 'yes';
    comedycons = profile['comedycons'] == 'yes';
    vaani = profile['vaani'] == 'yes';
    literati = profile['literati'] == 'yes';
    roots = profile['roots'] == 'yes';
    design = profile['design'] == 'yes';
    lifestyle = profile['lifestyle'] == 'yes';
    super.initState();
  }

  Future getImage() async {
//    dp = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  loading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
              child: CircularProgressIndicator()
          );
        }
    );
  }

  update() async {

    FocusScope.of(context).requestFocus(new FocusNode());
    loading();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (hostel == null) {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Please select hostel"),
        ],
      )));
      return;
    }

    if (year == null) {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Please select year"),
        ],
      )));
      return;
    }

    if (phoneController.text.length != 10) {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Please enter a valid mobile number"),
        ],
      )));
      return;
    }

    if (emailController.text.indexOf("@") < 1 || emailController.text.substring(emailController.text.indexOf("@")).indexOf(".") < 2) {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Please enter a valid email address"),
        ],
      )));
      return;
    }

    var response;
    try {
      response = (await http.post(profileUpdateURL,
        body: {
          "rollno": profile['rollno'],
          "username": prefs.getString('username'),
          "name": profile['name'],
          "nickname": nicknameController.text,
          "intro": introController.text,
          "hostel": hostel,
          "year": year,
          "mobile": phoneController.text,
          "email": emailController.text,
          "pixels": pixels ? "yes" : "",
          "rang": rang ? "yes" : "",
          "silverscreen": silverscreen ? "yes" : "",
          "symphony": symphony ? "yes" : "",
          "insync": insync ? "yes" : "",
          "fourthwall": fourthwall ? "yes" : "",
          "wespeak": wespeak ? "yes" : "",
          "comedycons": comedycons ? "yes" : "",
          "vaani": vaani ? "yes" : "",
          "literati": literati ? "yes" : "",
          "roots": roots ? "yes" : "",
          "design": design ? "yes" : "",
          "lifestyle": lifestyle ? "yes" : ""
        }
      )).body;
    } catch (ex) {
      print('Ex');
      print(ex);
      print('Ex');
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Network error"),
        ],
      )));
      return;
    }

    print(response);

    Map jsonData;
    try {
      jsonData = jsonDecode(response);
    } catch (ex) {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Some error occurred. Please try again"),
        ],
      )));
      return;
    }

    if (jsonData.containsKey("error")) {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Unable to submit. Please try again"),
        ],
      )));
      return;
    }

    prefs.remove('profile');
    prefs.setString('profile', response);

    Navigator.pop(context);
    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              key: editFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  GestureDetector(
                    onTap: () {
                      print('Tapped');
                      getImage();
                    },
                    child: CircleAvatar(
                      radius: 80.0,
                      backgroundImage: (dp != null) ? FileImage(dp) : (profile["pic_url"] != null ? CachedNetworkImageProvider(profile["pic_url"]) : AssetImage('assets/images/add.png')),
                    ),
                  ),

                  SizedBox(height: 16.0),

                  Text(
                    profile['name'],
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 16.0),

                  Container(
                    width: 250.0,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: nicknameController,
                      decoration: InputDecoration(
                        hintText: 'Choose an optional Nickname',
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.0),

                  Text(
                    profile['rollno'],
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),

                  SizedBox(height: 16.0),

                  TextFormField(
                    textAlign: TextAlign.center,
                    controller: introController,
                    decoration: InputDecoration(
                      hintText: 'Add an intro to your profile',
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                  ),

                  SizedBox(height: 24.0),

                  Card(
                    elevation: 2.0,
                    child: Row(
                      children: <Widget>[

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
                            child: FormField(
                              builder: (FormFieldState state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: '    Hostel',
                                  ),
                                  isEmpty: hostel == 'Choose Hostel',
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: hostel,
                                      isDense: true,
                                      onChanged: (String newValue) {
                                        setState(() {
                                          hostel = newValue;
                                          state.didChange(newValue);
                                        });
                                      },
                                      items: hostels.map((String value) {
                                        return new DropdownMenuItem(
                                          value: value,
                                          child: new Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        Container(
                          height: 60.0,
                          width: 1.0,
                          color: Colors.grey,
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
                            child: FormField(
                              builder: (FormFieldState state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: '    Year',
                                  ),
                                  isEmpty: year == 'Choose Year',
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: year,
                                      isDense: true,
                                      onChanged: (String newValue) {
                                        setState(() {
                                          year = newValue;
                                          state.didChange(newValue);
                                        });
                                      },
                                      items: years.map((String value) {
                                        return new DropdownMenuItem(
                                          value: value,
                                          child: new Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                  SizedBox(height: 16.0),

                  Card(
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.phone),
                                SizedBox(width: 16.0),
                                Expanded(
                                  child: TextFormField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: 'Whatsapp Mobile Number',
                                      contentPadding: EdgeInsets.all(8.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.email),
                                SizedBox(width: 16.0),
                                Expanded(
                                  child: TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'Email Address',
                                      contentPadding: EdgeInsets.all(8.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16.0),

                  Card(
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'CLUBS OF INTEREST',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: 8.0),

                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: pixels,
                                      onChanged: (value) {
                                        setState(() {
                                          pixels = value;
                                        });
                                      }
                                    ),
                                    Text('Pixels'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: rang,
                                        onChanged: (value) {
                                          setState(() {
                                            rang = value;
                                          });
                                        }
                                    ),
                                    Text('Rang'),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: silverscreen,
                                        onChanged: (value) {
                                          setState(() {
                                            silverscreen = value;
                                          });
                                        }
                                    ),
                                    Text('Silverscreen'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: symphony,
                                        onChanged: (value) {
                                          setState(() {
                                            symphony = value;
                                          });
                                        }
                                    ),
                                    Text('Symphony'),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: insync,
                                        onChanged: (value) {
                                          setState(() {
                                            insync = value;
                                          });
                                        }
                                    ),
                                    Text('InSync'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: fourthwall,
                                        onChanged: (value) {
                                          setState(() {
                                            fourthwall = value;
                                          });
                                        }
                                    ),
                                    Text('Fourthwall'),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: wespeak,
                                        onChanged: (value) {
                                          setState(() {
                                            wespeak = value;
                                          });
                                        }
                                    ),
                                    Text('We Speak'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: comedycons,
                                        onChanged: (value) {
                                          setState(() {
                                            comedycons = value;
                                          });
                                        }
                                    ),
                                    Text('Comedy Cons'),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: vaani,
                                        onChanged: (value) {
                                          setState(() {
                                            vaani = value;
                                          });
                                        }
                                    ),
                                    Text('Vaani'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: literati,
                                        onChanged: (value) {
                                          setState(() {
                                            literati = value;
                                          });
                                        }
                                    ),
                                    Text('Literati'),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: roots,
                                        onChanged: (value) {
                                          setState(() {
                                            roots = value;
                                          });
                                        }
                                    ),
                                    Text('Roots'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: design,
                                        onChanged: (value) {
                                          setState(() {
                                            design = value;
                                          });
                                        }
                                    ),
                                    Text('Design'),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: lifestyle,
                                        onChanged: (value) {
                                          setState(() {
                                            lifestyle = value;
                                          });
                                        }
                                    ),
                                    Text('Lifestyle'),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),


                  SizedBox(height: 24.0),

                  RaisedButton(
                    onPressed: () {
                      update();
                    },
                    padding: EdgeInsets.fromLTRB(64.0, 16.0, 64.0, 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('UPDATE'),
                      ],
                    ),
                    color: Colors.indigoAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  ),

                  SizedBox(height: 16.0),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//TODO