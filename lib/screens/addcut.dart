import 'dart:convert';
import 'package:alamia/constants.dart';
import 'package:alamia/screens/home_screen.dart';
import 'package:alamia/widgets/custom_button.dart';
import 'package:alamia/widgets/custom_formfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCutScreen extends StatefulWidget {
  static const roureName = 'add_cut';
  @override
  _AddCutScreenState createState() => _AddCutScreenState();
}

class _AddCutScreenState extends State<AddCutScreen> {
  List<DropdownMenuItem> addCut = [
    DropdownMenuItem(
      child: Center(
        child: Text(
          'اختر نوع الطلب',
          style: TextStyle(
            fontSize: 18,
            color: darkBlue,
          ),
        ),
      ),
      value: 'اختر',
    ),
    DropdownMenuItem(
      child: Center(
        child: Text(
          'خصم',
          style: TextStyle(
            fontSize: 18,
            color: darkBlue,
          ),
        ),
      ),
      value: '1',
    ),
    DropdownMenuItem(
      child: Center(
        child: Text(
          'حافز',
          style: TextStyle(
            fontSize: 18,
            color: darkBlue,
          ),
        ),
      ),
      value: '2',
    ),
  ];

  DropdownButton addCutButton() {
    return DropdownButton(
      focusNode: typeNode,
      itemHeight: 58.0,
      isExpanded: true,
      iconSize: 35.0,
      underline: Divider(
        color: Colors.white,
      ),
      items: addCut,
      value: selectedType,
      onChanged: (value) {
        setState(() {
          selectedType = value;
          print(selectedType);
        });
        FocusScope.of(context).requestFocus(sumNode);
      },
    );
  }

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  void dispose() {
    typeNode.dispose();
    sumNode.dispose();
    reasonNode.dispose();
    super.dispose();
  }

  final typeNode = FocusNode();
  final sumNode = FocusNode();
  final reasonNode = FocusNode();
  String selectedType = 'اختر';
  String addCutSum;
  String addCutReason;
  String currentUserId;
  String userlink;

  void getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = preferences.getString('user_id');
      userlink = preferences.getString('user_link');
    });
  }

  Future submitRequest(String id, String type, String userId, String value,
      String reason, String domain) async {
    final url = 'http://$domain/api/cutadd.php';
    var response = await http.post(
      url,
      body: {
        'employee_id': id,
        'type': type,
        'user_id': userId,
        'value': value,
        'description': reason
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body) == 2) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('تم الارسال بنجاح'),
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
      } else if (jsonDecode(response.body) == 1) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
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
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
    }
  }

  final _form = GlobalKey<FormState>();
  void saveForm() {
    _form.currentState.validate();
    _form.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    final empId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('اضافة خصم/ حافز'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 58.0,
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    color: Colors.white,
                  ),
                  child: addCutButton(),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 58.0,
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    color: Colors.white,
                  ),
                  child: CustomFormField(
                    hintText: 'أضف القيمة',
                    focusNode: sumNode,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      addCutSum = value;
                    },
                    onSubmitted: (value) {
                      FocusScope.of(context).requestFocus(reasonNode);
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'لا يمكن ترك الحقل فارغ';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 58.0,
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    color: Colors.white,
                  ),
                  child: CustomFormField(
                    hintText: 'أضف السبب',
                    focusNode: reasonNode,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      addCutReason = value;
                    },
                    onSubmitted: (value) {
                      addCutReason = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'لا يمكن ترك الحقل فارغ';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: CustomButton(
                    buttonColor: darkBlue,
                    child: Center(
                      child: Text(
                        'ارسال الطلب',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ontap: () async {
                      var connectivity =
                          await (Connectivity().checkConnectivity());
                      if (connectivity == ConnectivityResult.none) {
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
                        submitRequest(empId, selectedType, currentUserId,
                            addCutSum, addCutReason, userlink);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: orange,
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'العودة للرئيسية',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
