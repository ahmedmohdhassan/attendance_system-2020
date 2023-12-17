import 'dart:convert';
import 'package:alamia/classes/user.dart';
import 'package:alamia/constants.dart';
import 'package:alamia/screens/home_screen.dart';
import 'package:alamia/widgets/custom_formfield.dart';
import 'package:alamia/widgets/scan_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;

class LogInScreen extends StatefulWidget {
  static const routeName = 'log_in';
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  String username;
  String password;
  String userlink;
  TextEditingController _controller = TextEditingController();
  final userNameNode = FocusNode();
  final passWordNode = FocusNode();
  final userlinkNode = FocusNode();
  final _key = GlobalKey<FormState>();
  ConnectivityResult connectivityResult;

  Future scanUserLink() async {
    var result = await scanner.scan();
    if (result != null) {
      setState(() {
        userlink = result;
        _controller.text = userlink;
      });
    }
  }

  void saveForm() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('user_link', userlink);
    _key.currentState.validate();
    _key.currentState.save();
  }

  Future<void> signIn(String domainName) async {
    final url = 'http://$domainName/api/login.php';
    var response = await http.post(
      url,
      body: {
        'myuser': '$username',
        'mypass': '$password',
      },
    );
    print(response.body);
    print(response.statusCode);
    var data = jsonDecode(response.body);
    User user = User(
      id: data['user_id'],
      userName: data['user_name'],
      userLevel: data['user_level'],
    );
    if (jsonDecode(response.body) != 0) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('user_level', user.userLevel);
      preferences.setString('user_id', user.id);

      Navigator.of(context)
          .pushNamed(MyHomePage.routeName, arguments: user.userLevel);
    } else if (jsonDecode(response.body) == 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('خطأ في الاتصال'),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok')),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    userNameNode.dispose();
    passWordNode.dispose();
    userlinkNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: ListView(
          children: [
            SizedBox(
              height: 40,
            ),
            Center(child: Image.asset('images/mtech_logo.png')),
            SizedBox(
              height: 20,
            ),
            CustomFormField(
              hintText: 'رابط المستخدم',
              controller: _controller,
              focusNode: userlinkNode,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                userlink = value;
              },
              onSubmitted: (value) {
                FocusScope.of(context).requestFocus(userNameNode);
              },
              onSaved: (value) {
                userlink = value;
              },
              validator: (String value) {
                if (value.isEmpty) {
                  return 'من فضلك ادخل رابط المستخدم';
                } else {
                  return null;
                }
              },
              suffixIcon: ScanButton(
                ontap: scanUserLink,
              ),
            ),
            CustomFormField(
              validator: (String value) {
                if (value.isEmpty) {
                  return 'من فضلك ادخل اسم المستخدم';
                } else {
                  return null;
                }
              },
              textInputAction: TextInputAction.next,
              focusNode: userNameNode,
              onChanged: (value) {
                username = value;
              },
              onSubmitted: (value) {
                FocusScope.of(context).requestFocus(passWordNode);
              },
              onSaved: (value) {
                username = value;
              },
              hintText: 'اسم المستخدم',
            ),
            CustomFormField(
              validator: (String value) {
                if (value.isEmpty) {
                  return 'من فضلك ادخل كلمة السر';
                } else {
                  return null;
                }
              },
              textInputAction: TextInputAction.done,
              focusNode: passWordNode,
              onChanged: (value) {
                password = value;
              },
              onSubmitted: (value) {
                password = value;
              },
              onSaved: (value) {
                password = value;
              },
              hintText: 'كلمة السر',
              obscure: true,
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () async {
                connectivityResult = await (Connectivity().checkConnectivity());
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
                          child: Text('Ok'),
                        ),
                      ],
                    ),
                  );
                } else {
                  saveForm();
                  signIn(userlink);
                }
              },
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: orange,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset('images/login_icon.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
