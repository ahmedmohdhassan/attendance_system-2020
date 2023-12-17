import 'dart:convert';
import 'package:alamia/screens/emp_details.dart';
import 'package:alamia/screens/emp_list.dart';
import 'package:alamia/screens/login_screen.dart';
import 'package:alamia/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:alamia/constants.dart';
import 'package:http/http.dart' as http;
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = 'Home_page';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String empId;
  String userId;
  String userLevel;
  String type;
  String fromList;
  String userlink;
  Future scanQr() async {
    var result = await scanner.scan();
    print(result);
    setState(() {
      empId = result;
    });
  }

  Future submitCase(
    String id,
    String type,
    String currentUserId,
    String fromList,
    String domain,
  ) async {
    final url = 'http://$domain/api/inout.php';
    var response = await http.post(
      url,
      body: {
        'employee_id': id,
        'type': type,
        'user_id': currentUserId,
        'fromList': fromList,
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body) == 2) {
        if (type == '1') {
          Navigator.of(context).pushNamed(
            EmpDetails.routeName,
            arguments: id,
          );
        } else if (type == '2') {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text('تم التسجيل بنجاح'),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'),
                )
              ],
            ),
          );
        }
      } else if (jsonDecode(response.body) == 3) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('تم التسجيل مسبقا'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ok'),
                  )
                ],
              );
            });
      } else if (jsonDecode(response.body) == 4) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('تم التسجيل للمرة الثانية'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ok'),
                  )
                ],
              );
            });
      } else if (jsonDecode(response.body) == 5) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(' تم التسجيل مسبقا بدون الكود'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ok'),
                  )
                ],
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('خطأ في الاتصال'),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'),
                )
              ],
            );
          });
    }
  }

  void getuserID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('user_id');
      userLevel = preferences.getString('user_level');
      userlink = preferences.getString('user_link');
    });
  }

  void logOut() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('user_id', null);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LogInScreen(),
        ),
        (route) => false);
  }

  @override
  void initState() {
    getuserID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: Center(
        child: orientation == Orientation.landscape
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  userLevel == '3'
                      ? Center()
                      : CustomButton(
                          buttonColor: orange,
                          width: width * 0.6,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('images/qr.png'),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'حضور',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          ontap: () {
                            scanQr().then((_) {
                              if (empId == null) {
                                return;
                              } else {
                                submitCase(empId, '1', userId, '0', userlink);
                              }
                            });
                          },
                        ),
                  userLevel == '3'
                      ? Center()
                      : CustomButton(
                          buttonColor: Colors.white,
                          width: width * 0.6,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/qr.png',
                                  color: orange,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'انصراف',
                                  style: TextStyle(color: orange),
                                ),
                              ],
                            ),
                          ),
                          ontap: () {
                            scanQr().then((_) {
                              if (empId == null) {
                                return;
                              } else {
                                submitCase(empId, '2', userId, '0', userlink);
                              }
                            });
                          },
                        ),
                  CustomButton(
                    ontap: () {
                      Navigator.of(context).pushNamed(EmpScreen.routeName);
                    },
                    buttonColor: Colors.white,
                    width: width * 0.6,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.list,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'قائمة الموظفين',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomButton(
                    ontap: () {
                      logOut();
                    },
                    buttonColor: Colors.red[700],
                    width: width * 0.6,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'تسجيل الخروج',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  userLevel == '3'
                      ? Center()
                      : CustomButton(
                          buttonColor: orange,
                          width: width * 0.6,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('images/qr.png'),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'حضور',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          ontap: () {
                            scanQr().then((_) {
                              if (empId == null) {
                                return;
                              } else {
                                submitCase(empId, '1', userId, '0', userlink);
                              }
                            });
                          },
                        ),
                  userLevel == '3'
                      ? Center()
                      : CustomButton(
                          buttonColor: Colors.white,
                          width: width * 0.6,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/qr.png',
                                  color: orange,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'انصراف',
                                  style: TextStyle(color: orange),
                                ),
                              ],
                            ),
                          ),
                          ontap: () {
                            scanQr().then((_) {
                              if (empId == null) {
                                return;
                              } else {
                                submitCase(empId, '2', userId, '0', userlink);
                              }
                            });
                          },
                        ),
                  CustomButton(
                    ontap: () {
                      Navigator.of(context).pushNamed(EmpScreen.routeName);
                    },
                    buttonColor: Colors.white,
                    width: width * 0.6,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.list,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'قائمة الموظفين',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomButton(
                    ontap: () {
                      logOut();
                    },
                    buttonColor: Colors.red[700],
                    width: width * 0.6,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'تسجيل الخروج',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
