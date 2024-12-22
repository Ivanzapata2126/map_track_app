// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  final bool isDarkmode;
  static const Color primaryColor = Color(0xffE65050);
  static const Color secondaryColor = Color(0xffC8C8C8);
  static const colorList = <Color>[
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.orange,
  Colors.pink,
  Colors.pinkAccent
];
static const List<IconData> markerIcons = [
  Icons.location_on,
  Icons.flag,
  Icons.star,
  Icons.favorite,
  Icons.home,
  Icons.work,
];
  AppTheme({this.isDarkmode = false});


  final lightTheme = ThemeData(
    useMaterial3: true,
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: primaryColor
    ),
    tabBarTheme: TabBarTheme(
      labelStyle: GoogleFonts.aBeeZee().copyWith(fontSize: 17, color: Colors.white),
      unselectedLabelStyle: GoogleFonts.aBeeZee().copyWith(fontSize: 17, color: Colors.white),
      overlayColor: WidgetStatePropertyAll(secondaryColor)
    ),
    dialogBackgroundColor: secondaryColor,
        unselectedWidgetColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
          extendedTextStyle: TextStyle(color: Colors.white)
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          iconTheme: IconThemeData(
            color: Colors.white
          )
        ),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.aBeeZee().copyWith(
              fontSize: 30, fontWeight: FontWeight.normal, color: Colors.white),
          titleMedium: GoogleFonts.aBeeZee().copyWith(
              fontSize: 24, fontWeight: FontWeight.normal, color: Colors.white),
          titleSmall:
              GoogleFonts.aBeeZee().copyWith(fontSize: 17, color: Colors.white),
        ),
  );
  final darkTheme = ThemeData(
    useMaterial3: true,
    
    tabBarTheme: TabBarTheme(
      labelStyle: GoogleFonts.aBeeZee().copyWith(fontSize: 17, color: Colors.white),
      unselectedLabelStyle: GoogleFonts.aBeeZee().copyWith(fontSize: 17, color: Colors.white),
      overlayColor: WidgetStatePropertyAll(secondaryColor)
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.black
    ),
    
    dialogBackgroundColor: secondaryColor.withOpacity(0.7),
        unselectedWidgetColor: Colors.white,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
          extendedTextStyle: TextStyle(color: Colors.white)
        ),
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        scaffoldBackgroundColor: primaryColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.white
          )
        ),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.aBeeZee().copyWith(
              fontSize: 30, fontWeight: FontWeight.normal, color: Colors.white),
          titleMedium: GoogleFonts.aBeeZee().copyWith(
              fontSize: 24, fontWeight: FontWeight.normal, color: Colors.white),
          titleSmall:
              GoogleFonts.aBeeZee().copyWith(fontSize: 17, color: Colors.white),
        ),
  );

  ThemeData getTheme() => isDarkmode ? darkTheme : lightTheme;

  AppTheme copyWith({bool? isDarkmode}) => AppTheme(
      isDarkmode: isDarkmode ?? this.isDarkmode);
}