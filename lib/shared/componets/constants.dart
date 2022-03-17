import 'package:flutter/material.dart';

final String eventTable = "events";
String? devicetoken = "";
String API_FCM_KEY =
    "AAAAzOQUmXs:APA91bH_-4wN-NQ6vrootxn4u6ZlySVuU3N0qNZRJK6ejBR3Sv9qiYJuTmRDkXlRjvp6kGJ2jXaYEJKEJFN-js2KxBmlog2JFfg3Ae8xrCjjrrLzSCmC4dzErzgCr-Y9JuP1VnkyBkko";

//NOTE ----------Get Date Formated For Task -----------------------------
String getDateFormated(String date) {
  List<String> listdate = date.split("T");
  List<String> list1date = listdate[1].split(":");

  return list1date[0] + ":" + list1date[1] + "   " + listdate[0];
}



// NOTE: style
/// NAME         SIZE  WEIGHT  SPACING
/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headline5    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// subtitle1    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// body1        16.0  regular  0.5   (bodyText1)
/// body2        14.0  regular  0.25  (bodyText2)
/// button       14.0  medium   1.25
/// caption      12.0  regular  0.4
/// overline     10.0  regular  1.5