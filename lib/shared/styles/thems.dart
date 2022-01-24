import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo_tasks_with_alert/shared/styles/colors.dart';

ThemeData darkThem() => ThemeData(
      scaffoldBackgroundColor: HexColor('#525252'),
      primarySwatch: defaultColor,
      appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: HexColor('#525252'),
          elevation: 0,
          actionsIconTheme: IconThemeData(color: Colors.white),
          backwardsCompatibility: false,
          titleTextStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: HexColor('#525252'),
            statusBarIconBrightness: Brightness.light,
          )),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: defaultColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: HexColor('#525252'),
          unselectedItemColor: Colors.grey),

      //NOTE : set default bodytext1
      textTheme: TextTheme(
        bodyText1: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        subtitle1: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        bodyText2: TextStyle(
          color: Colors.white,
        ),
        headline5: TextStyle(color: defaultColor, fontWeight: FontWeight.bold),
      ),
    );

ThemeData lightTheme() => ThemeData(
      primarySwatch: defaultColor,
      appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          actionsIconTheme: IconThemeData(color: Colors.black),
          backwardsCompatibility: false,
          titleTextStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          )),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: defaultColor),

      //NOTE : set default bodytext1
      textTheme: TextTheme(
          bodyText1: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(
            color: Colors.black,
          ),
          subtitle1:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          headline5:
              TextStyle(color: defaultColor, fontWeight: FontWeight.bold)),
    );
