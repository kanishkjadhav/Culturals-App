import 'package:flutter/material.dart';


class SendNotificationScreen extends StatefulWidget {
  @override
  _SendNotificationScreenState createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {

  static GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final sendNotificationFormKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  bool later = false;
  String date = 'Date and Time';

  send() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Send Notification'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: Form(
              key: sendNotificationFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter Title';
                      }
                    },
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
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
                        return 'Please enter Body';
                      }
                    },
                    controller: bodyController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Body',
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
                        value: later,
                        onChanged: (value) {
                          setState(() {
                            later = value;
                          });
                        },
                      ),
                      Text('Schedule for later', style: TextStyle(fontSize: 16.0)),
                    ],
                  ),

                  SizedBox(height: 18.0),

                  !later ? SizedBox() :
                  RaisedButton(
                    onPressed: () async {
                      DateTime chosenDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                      if (chosenDate == null) return;
                      TimeOfDay chosenTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                      if (chosenTime == null) return;

                      DateTime chosenDateTime = DateTime(chosenDate.year, chosenDate.month, chosenDate.day, chosenTime.hour, chosenTime.minute);

                      if (chosenDateTime.isBefore(DateTime.now().add(Duration(minutes: 15)))) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(child: Text('Scheduling time should be atleast 15 minutes from now')),
                          ],
                        )));
                        return;
                      }

                      setState(() {
                        date = chosenDateTime.toString();
                      });
                    },
                    elevation: 1.0,
                    padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                    child: Text(date, style: TextStyle(fontSize: 16.0)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  ),

                  !later ? SizedBox() :
                  SizedBox(height: 18.0),

                  RaisedButton(
                    onPressed: () {
                      send();
                    },
                    padding: EdgeInsets.fromLTRB(64.0, 16.0, 64.0, 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('SEND'),
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