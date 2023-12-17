import 'package:alamia/constants.dart';
import 'package:flutter/material.dart';

class ScanButton extends StatelessWidget {
  final Function ontap;
  ScanButton({this.ontap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: darkBlue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              'images/qr.png',
            ),
          ),
        ),
      ),
    );
  }
}
