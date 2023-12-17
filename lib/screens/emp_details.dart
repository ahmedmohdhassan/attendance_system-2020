import 'package:alamia/constants.dart';
import 'package:alamia/providers/emprovider.dart';
import 'package:alamia/screens/addcut.dart';
import 'package:alamia/screens/home_screen.dart';
import 'package:alamia/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmpDetails extends StatefulWidget {
  static const routeName = 'Emp_details';
  @override
  _EmpDetailsState createState() => _EmpDetailsState();
}

class _EmpDetailsState extends State<EmpDetails> {
  String currentUserLevel;
  bool isLoading;
  bool isInite = true;

  setLevel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currentUserLevel = preferences.getString('user_level');
    });
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    setLevel();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInite) {
      Provider.of<Emprovider>(context).fetchEmps().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInite = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final empId = ModalRoute.of(context).settings.arguments as String;
    final selectedEmp = Provider.of<Emprovider>(context, listen: false)
        .empList
        .firstWhere((emp) => emp.id == empId);
    return isLoading == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(selectedEmp.name),
            ),
            body: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: ListView(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Container(
                        height: height * 0.3,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                        ),
                        child: selectedEmp.imageUrl == null
                            ? Image.asset(
                                'images/emp.jpeg',
                                fit: BoxFit.fill,
                              )
                            : Image.network(
                                selectedEmp.imageUrl,
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      selectedEmp.name,
                      style: TextStyle(
                        fontSize: 20,
                        color: darkBlue,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      selectedEmp.department,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black12,
                    ),
                    child: Center(
                      child: Text(
                        '${selectedEmp.id}',
                        style: TextStyle(
                          fontSize: 20,
                          color: orange,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    child: currentUserLevel == '2'
                        ? Center(
                            child: Text(
                              'تم التسجيل',
                              style: TextStyle(
                                fontSize: 20,
                                color: orange,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          )
                        : Text(''),
                  ),
                  SizedBox(
                    child: currentUserLevel == '3'
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: CustomButton(
                              buttonColor: darkBlue,
                              child: Center(
                                child: Text(
                                  'اضافة حافز او خصم',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              ontap: () {
                                Navigator.of(context).pushNamed(
                                  AddCutScreen.roureName,
                                  arguments: selectedEmp.id,
                                );
                              },
                            ),
                          )
                        : Text(''),
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
                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(
                        //     builder: (context) => MyHomePage(),
                        //   ),
                        // );
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(),
                            ),
                            (route) => false);
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
          );
  }
}
