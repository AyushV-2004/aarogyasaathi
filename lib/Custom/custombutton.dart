import 'package:flutter/material.dart';

import 'customcolor.dart';

Widget MyCustomButton(String text) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10, top: 35),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Color.fromARGB(255, 38, 207, 74),
                Color.fromARGB(255, 38, 207, 74)
              ])),
      height: 50,
      width: 310,
      child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: DISPLAY_TEXT_COLOR,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          )),
    ),
  );
}