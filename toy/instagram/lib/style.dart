import 'package:flutter/material.dart';

var _var1;

var theme = ThemeData(
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(textStyle: TextStyle(color: Colors.black))),
    iconTheme: IconThemeData(color: Colors.blue),
    appBarTheme: AppBarTheme(
        color: Colors.white,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
        actionsIconTheme: IconThemeData(color: Colors.black)),
    textTheme: TextTheme(
      bodyText2: TextStyle(color: Colors.black),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white, selectedItemColor: Colors.black));
