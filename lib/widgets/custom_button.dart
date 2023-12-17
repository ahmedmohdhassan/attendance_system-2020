import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color buttonColor;
  final Widget child;
  final double width;
  final Function ontap;
  CustomButton({
    this.buttonColor,
    this.child,
    this.width,
    this.ontap,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          height: 50,
          width: width,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
