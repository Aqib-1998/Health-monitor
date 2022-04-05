// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

ThemeData primaryTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: kWhiteColor,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    scaffoldBackgroundColor: kWhiteColor,
    textTheme: GoogleFonts.poppinsTextTheme(),
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(secondary: Colors.transparent)
        .copyWith(secondary: kMainColor, primary: kMainColor));
