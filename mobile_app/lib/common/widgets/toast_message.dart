import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void message(String message,
    {String title = 'Error', bool isError = true, bool isInfo = false}) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(
          message,
          style: GoogleFonts.raleway(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
      duration: const Duration(seconds: 3,),
      elevation: 2,
      dismissDirection: DismissDirection.endToStart,
      backgroundColor: isError ? Colors.red : (isInfo ? Colors.blue : Color(0xff13a866)),
    ),
  );
}
