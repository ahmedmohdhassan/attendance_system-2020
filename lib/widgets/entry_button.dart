import 'package:flutter/material.dart';

class EntryButton extends StatelessWidget {
  const EntryButton({
    this.backgroundColor,
    this.fontColor,
    this.text,
    this.ontap,
  });

  final Color backgroundColor;
  final Color fontColor;
  final String text;
  final Function ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: fontColor,
            ),
          ),
        ),
      ),
    );
  }
}
