import 'package:alamia/Screens/home_screen.dart';
import 'package:alamia/providers/emprovider.dart';
import 'package:alamia/screens/addcut.dart';
import 'package:alamia/screens/emp_details.dart';
import 'package:alamia/screens/emp_list.dart';
import 'package:alamia/screens/login_screen.dart';
import 'package:alamia/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Emprovider>(
      create: (context) => Emprovider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Bahij_Insan',
          scaffoldBackgroundColor: darkBlue,
          appBarTheme: AppBarTheme(
            color: darkBlue,
            centerTitle: true,
          ),
        ),
        home: StartScreen(),
        routes: {
          MyHomePage.routeName: (context) => MyHomePage(),
          EmpScreen.routeName: (context) => EmpScreen(),
          EmpDetails.routeName: (context) => EmpDetails(),
          AddCutScreen.roureName: (context) => AddCutScreen(),
          LogInScreen.routeName: (context) => LogInScreen(),
        },
      ),
    );
  }
}
