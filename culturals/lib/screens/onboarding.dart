import 'package:culturals/screens/home.dart';
import 'package:culturals/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';



class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  doneOnBoard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboarded', true);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      [
        PageViewModel(
          pageColor: Colors.white,
          bubbleBackgroundColor: Colors.red[900],
          body: Text('Discover all events around you organised by Culturals@IITB',),
          title: Text('DISCOVER'),
          mainImage: Image.asset(
            'assets/images/onboarding_1.png',
            height: 285.0,
            width: 285.0,
            alignment: Alignment.center,
          ),
          textStyleTitle: TextStyle(color: Colors.red[800], fontSize: 24.0, fontWeight: FontWeight.bold),
          textStyleBody: TextStyle(color: Colors.red[800], fontSize: 18.0),
        ),
        PageViewModel(
          pageColor: Colors.white,
          bubbleBackgroundColor: Colors.red[900],
          body: Text('Although Pippo is a lazy panda like all of us, he doesn\'t sit idly in his room. He tries all genres of Cult in IITB.\n\n Be like Pippo.'),
          title: Text('PIPPO\'S JOURNEY'),
          mainImage: Image.asset(
            'assets/images/onboarding_2.png',
            height: 285.0,
            width: 285.0,
            alignment: Alignment.center,
          ),
          textStyleTitle: TextStyle(color: Colors.red[800], fontSize: 24.0, fontWeight: FontWeight.bold),
          textStyleBody: TextStyle(color: Colors.red[800], fontSize: 18.0),
        )
      ],
      onTapDoneButton: (){
        doneOnBoard();
      },
      showSkipButton: false,
      pageButtonTextStyles: new TextStyle(
        color: Colors.red[900],
        fontSize: 20.0,
      ),
    );
  }

}