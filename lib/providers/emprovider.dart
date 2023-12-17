import 'dart:convert';
import 'package:alamia/classes/employee.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Emprovider with ChangeNotifier {
  List<Employee> _empList = [];

  List<Employee> get empList {
    return [..._empList];
  }

  Future fetchEmps() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var domain = preferences.getString('user_link');
    final url = 'http://$domain/api/employees.php';
    final response = await http.get(url);
    print(response.body);
    print(response.statusCode);

    final data = jsonDecode(response.body);
    List<Employee> fetchedemps = [];
    for (Map i in data) {
      fetchedemps.add(
        Employee(
          name: i['employee_name'],
          id: i['employee_id'].toString(),
          department: i['employee_department'],
          imageUrl: i['employee_photo'],
        ),
      );
    }
    _empList = fetchedemps;
    notifyListeners();
    return Future.value();
  }
}
