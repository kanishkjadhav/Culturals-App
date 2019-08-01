import 'dart:convert';
import 'dart:io';
import 'package:culturals/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:culturals/api.dart';
import 'package:culturals/screens/login.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';



class CreateProfileScreen extends StatefulWidget {
  final String username;
  final String name;
  final String rollno;

  CreateProfileScreen({Key key, @required this.username, @required this.name, @required this.rollno}) : super(key: key);

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState(username: username, name: name, rollno: rollno);
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {

  final String username;
  final String name;
  final String rollno;
  _CreateProfileScreenState({@required this.username, @required this.name, @required this.rollno}) : super();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final createFormKey = GlobalKey<FormState>();
  List<String> hostels = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15A", "15B", "15C", "16A", "16B", "16C", "Tansa"];
  List<String> years = ["1", "2", "3", "4", "5"];


  File dp;
  final nicknameController = TextEditingController();
  final introController = TextEditingController();
  String hostel;
  String year;
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  bool pixels = false;
  bool rang = false;
  bool silverscreen = false;
  bool symphony = false;
  bool insync = false;
  bool fourthwall = false;
  bool wespeak = false;
  bool comedycons = false;
  bool vaani = false;
  bool literati = false;
  bool roots = false;
  bool design = false;
  bool lifestyle = false;

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

  create() async {

    FocusScope.of(context).requestFocus(new FocusNode());
    loading();

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
          "rollno": rollno,
          "username": username,
          "name": name,
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('profile');
    prefs.setString('profile', response);

    Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(profile: jsonData)));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Create Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              key: createFormKey,
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
                      backgroundImage: (dp != null) ? FileImage(dp) : AssetImage('assets/images/add.png'),
                    ),
                  ),

                  SizedBox(height: 16.0),

                  Text(
                    name,
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
                    rollno,
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
                      create();
                    },
                    padding: EdgeInsets.fromLTRB(64.0, 16.0, 64.0, 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('CREATE'),
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