import 'package:alamia/screens/home_screen.dart';
import 'package:alamia/screens/login_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartScreen extends StatefulWidget {
  static const routeName = 'start_screen';
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((_) async {
      connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('لا يوجد اتصال بالانترنت'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              )
            ],
          ),
        );
      } else {
        autoLogIn();
      }
    });
    super.initState();
  }

  String userId;
  ConnectivityResult connectivityResult;

  void autoLogIn() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    userId = _preferences.getString('user_id');
    if (userId == null) {
      Navigator.of(context).pushNamed(LogInScreen.routeName);
    } else {
      Navigator.of(context).pushNamed(
        MyHomePage.routeName,
        arguments: userId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 60,
          ),
          Center(
            child: Image.asset('images/mtech_logo.png'),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: Text(
              'نظام الحضور والانصراف',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
