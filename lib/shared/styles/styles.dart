import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
