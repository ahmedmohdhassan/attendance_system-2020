import 'package:flutter/material.dart';

const Color orange = Color(0xFFFF9600);
const Color grey = Color(0xFF707070);
const Color darkBlue = Color(0xFF1D1E3D);

const enabledBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.white, width: 0.0),
  borderRadius: BorderRadius.all(
    Radius.circular(30),
  ),
);

const errorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.red, width: 0.0),
  borderRadius: BorderRadius.all(
    Radius.circular(30),
  ),
);
