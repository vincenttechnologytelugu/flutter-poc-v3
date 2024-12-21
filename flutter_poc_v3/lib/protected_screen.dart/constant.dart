// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class constant {
  static final choose = GoogleFonts.paytoneOne(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: const Color(0xff000000));

  static TextStyle boldTextFeildStyle() {
    return TextStyle(
        fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.black);
  }

  static TextStyle lightTextFeildStyle() {
    return TextStyle(
        color: Colors.black45, fontSize: 20.0, fontWeight: FontWeight.w500);
  }

  static TextStyle semiBoldTextFeildStyle() {
    return TextStyle(
        color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold);
  }
}
