import 'package:flutter/material.dart';
import 'package:alamia/constants.dart';

class CustomFormField extends StatelessWidget {
  final Widget suffixIcon;
  final String hintText;
  final Function validator;
  final TextInputAction textInputAction;
  final bool obscure;
  final TextInputType keyboardType;
  final FocusNode focusNode;
  final Function onChanged;
  final Function onSubmitted;
  final Function onSaved;
  final Function ontap;
  final TextEditingController controller;
  CustomFormField({
    this.controller,
    this.hintText,
    this.validator,
    this.suffixIcon,
    this.textInputAction,
    this.keyboardType,
    this.obscure = false,
    this.focusNode,
    this.onChanged,
    this.ontap,
    this.onSaved,
    this.onSubmitted,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10.0,
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        obscureText: obscure,
        focusNode: focusNode,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.black38,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: enabledBorder,
          errorBorder: errorBorder,
          focusedBorder: enabledBorder,
        ),
        onChanged: onChanged,
        onSaved: onSaved,
        onFieldSubmitted: onSubmitted,
        onTap: ontap,
      ),
    );
  }
}
