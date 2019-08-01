import 'package:culturals/api.dart';
import 'package:culturals/screens/createprofile.dart';
import 'package:culturals/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:recase/recase.dart';
import 'dart:convert';



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final loginFormKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

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

  login() async {

    FocusScope.of(context).requestFocus(new FocusNode());
    loading();

    var response;
    try {
      response = (await http.post(loginURL, body: {"username": usernameController.text, "password": passwordController.text})).body;
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

    if (jsonData["error"] == 'connection') {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Some error occurred. Please try again"),
        ],
      )));
      return;
    }

    if (jsonData["error"] == 'incorrect') {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Incorrect LDAP Credentials"),
        ],
      )));
      return;
    }

    var profile;
    try {
      profile = (await http.post(profileURL + jsonData["rollno"])).body;
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

    print(profile);

    Map jsonProfile;
    try {
      jsonProfile = jsonDecode(profile);
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profile', profile);
    prefs.setString('username', jsonData["username"]);

    Navigator.pop(context);
    if (jsonProfile["name"] == "")
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateProfileScreen(
          username: jsonData["username"],
          name: ReCase(jsonData["name"].toString().toLowerCase()).titleCase,
          rollno: jsonData["rollno"]
      )));
    else
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(profile: jsonProfile,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 24.0),
                child: Form(
                  key: loginFormKey,
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        Image.asset(
                          'assets/images/cover_login.png',
                        ),

                        Expanded(flex: 2, child: SizedBox(height: 32.0)),

                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter LDAP ID';
                            }
                          },
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: 'LDAP ID',
                            contentPadding: EdgeInsets.fromLTRB(
                                24.0, 16.0, 24.0, 16.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                          ),
                        ),

                        SizedBox(height: 12.0),

                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Password';
                            }
                          },
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            contentPadding: EdgeInsets.fromLTRB(
                                24.0, 16.0, 24.0, 16.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                          ),
                        ),

                        Expanded(flex: 2, child: SizedBox(height: 32.0)),

                        RaisedButton(
                          onPressed: () {
                            if (loginFormKey.currentState.validate()) {
                              login();
                            }
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

                        SizedBox(height: 12.0),

                        RaisedButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) => HomeScreen(profile: null)));
                          },
                          padding: EdgeInsets.fromLTRB(64.0, 16.0, 64.0, 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('CONTINUE AS GUEST'),
                            ],
                          ),
                          color: Colors.indigoAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                        ),

                        Expanded(flex: 1, child: SizedBox(height: 12.0)),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}