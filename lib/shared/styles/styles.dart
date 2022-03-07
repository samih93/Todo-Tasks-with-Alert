import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_tasks_with_alert/shared/styles/thems.dart';

TextStyle get subHeaderStyle {
  return TextStyle(
    color: Get.isDarkMode ? Colors.grey.shade400 : Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 25,
  );
}

TextStyle get headerStyle {
  return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: Get.isDarkMode ? Colors.white : Colors.black);
}

TextStyle get eventheaderStyle {
  return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: Get.isDarkMode ? Colors.white : defaultLightColor);
}

TextStyle get titleofTaskitem {
  return TextStyle(
      fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white);
}

LinearGradient get orangeGradient {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.deepOrange,
      Colors.deepOrange.shade400,
      Colors.deepOrange.shade300,
    ],
  );
}
