import 'dart:io';
import 'package:flutter/material.dart';


class AddEventScreen extends StatefulWidget {
  final String name;
  final String phone;
  AddEventScreen({Key key, @required this.name, @required this.phone}) : super(key: key);
  @override
  _AddEventScreenState createState() => _AddEventScreenState(name: name, phone: phone);
}

class _AddEventScreenState extends State<AddEventScreen> {

  final String name;
  final String phone;
  _AddEventScreenState({@required this.name, @required this.phone}) : super();

  static GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final addEventFormKey = GlobalKey<FormState>();

  File poster;
  final nameController = TextEditingController();
  final venueController = TextEditingController();
  final descriptionController = TextEditingController();
  final contactNameController = TextEditingController();
  final contactNumberController = TextEditingController();
  String date = 'Date';
  String time = 'Time';
  bool notify = true;

  @override
  void initState() {
    contactNameController.text = name;
    contactNumberController.text = phone;
    super.initState();
  }

  add() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: Form(
              key: addEventFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
//                            getImage();
                          },
                          child: Image(
                            image: (poster != null) ? FileImage(poster) : AssetImage('assets/images/add1.png'),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18.0),

                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter Event Name';
                      }
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                      contentPadding: EdgeInsets.fromLTRB(
                          24.0, 16.0, 24.0, 16.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                  ),

                  SizedBox(height: 18.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          ).then((newDate) {
                            setState(() {
                              date = newDate.toString().substring(0,10);
                            });
                          });
                        },
                        elevation: 1.0,
                        padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                        child: Text(date, style: TextStyle(fontSize: 16.0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      ),
                      RaisedButton(
                        onPressed: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((newTime) {
                            setState(() {
                              time = newTime.toString().substring(10,15);
                            });
                          });
                        },
                        elevation: 1.0,
                        padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                        child: Text(time, style: TextStyle(fontSize: 16.0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      ),
                    ],
                  ),

                  SizedBox(height: 18.0),

                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter Venue';
                      }
                    },
                    controller: venueController,
                    decoration: InputDecoration(
                      labelText: 'Venue',
                      contentPadding: EdgeInsets.fromLTRB(
                          24.0, 16.0, 24.0, 16.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                  ),

                  SizedBox(height: 18.0),

                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter Description';
                      }
                    },
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      contentPadding: EdgeInsets.fromLTRB(
                          24.0, 16.0, 24.0, 16.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                  ),

                  SizedBox(height: 18.0),

                  TextFormField(
                    controller: contactNameController,
                    decoration: InputDecoration(
                      labelText: 'Contact Name',
                      contentPadding: EdgeInsets.fromLTRB(
                          24.0, 16.0, 24.0, 16.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                  ),

                  SizedBox(height: 18.0),

                  TextFormField(
                    controller: contactNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Contact Number',
                      contentPadding: EdgeInsets.fromLTRB(
                          24.0, 16.0, 24.0, 16.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                  ),

                  SizedBox(height: 18.0),

                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: notify,
                        onChanged: (value) {
                          setState(() {
                            notify = value;
                          });
                        },
                      ),
                      Text('Notify users about addition of event', style: TextStyle(fontSize: 16.0)),
                    ],
                  ),

                  SizedBox(height: 18.0),

                  RaisedButton(
                    onPressed: () {
                      add();
                    },
                    padding: EdgeInsets.fromLTRB(64.0, 16.0, 64.0, 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('ADD'),
                      ],
                    ),
                    color: Colors.indigoAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  ),

                  SizedBox(height: 18.0),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}