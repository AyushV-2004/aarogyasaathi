import 'package:flutter/material.dart';

Widget MyTextFieldWidget(
    TextEditingController controller,String? hintText) {
  return Container(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          controller: controller,
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
          obscureText: hintText == "Password" ? true : false,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontWeight: FontWeight.bold),

            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 206, 193, 193))),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 206, 193, 193))),
          ),
        ),
      ));
}
