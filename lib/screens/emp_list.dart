import 'dart:convert';
import 'package:alamia/constants.dart';
import 'package:alamia/providers/emprovider.dart';
import 'package:alamia/screens/emp_details.dart';
import 'package:alamia/screens/home_screen.dart';
import 'package:alamia/widgets/entry_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EmpScreen extends StatefulWidget {
  static const routeName = 'EmpScreen';
  @override
  _EmpScreenState createState() => _EmpScreenState();
}

class _EmpScreenState extends State<EmpScreen> {
  bool isLoading;
  bool isInite = true;
  @override
  void initState() {
    getuserID();
    setState(() {
      isLoading = true;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInite) {
      Provider.of<Emprovider>(context).fetchEmps().catchError((e) {
        showDialog(
          context: context,
          builder: (contex) => AlertDialog(
            content: Text('خطأ في الاتصال'),
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
      }).then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInite = false;
    super.didChangeDependencies();
  }

  String userId;
  String userLevel;
  String fromList;
  String userlink;

  void getuserID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('user_id');
      userLevel = preferences.getString('user_level');
      userlink = preferences.getString('user_link');
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
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MyHomePage(),
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

  @override
  Widget build(BuildContext context) {
    final employees = Provider.of<Emprovider>(context).empList;
    return Scaffold(
      appBar: AppBar(
        title: Text('الموظفين'),
        centerTitle: true,
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) => Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  padding: const EdgeInsets.all(5.0),
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      userLevel == '3'
                          ? Center()
                          : EntryButton(
                              text: 'انصراف',
                              backgroundColor: Colors.white,
                              fontColor: orange,
                              ontap: () {
                                isLoading = true;
                                submitCase(
                                  employees[index].id,
                                  '2',
                                  userId,
                                  '1',
                                  userlink,
                                ).then((_) => isLoading = false);
                              },
                            ),
                      GestureDetector(
                        onTap: () {
                          if (userLevel == '3') {
                            Navigator.of(context).pushNamed(
                              EmpDetails.routeName,
                              arguments: employees[index].id,
                            );
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              employees[index].name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: darkBlue,
                              ),
                            ),
                            Text(
                              employees[index].department,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      userLevel == '3'
                          ? Center()
                          : EntryButton(
                              ontap: () {
                                isLoading = true;
                                submitCase(
                                  employees[index].id,
                                  '1',
                                  userId,
                                  '1',
                                  userlink,
                                ).then((_) => isLoading = false);
                              },
                              backgroundColor: orange,
                              fontColor: darkBlue,
                              text: 'حضور',
                            ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
