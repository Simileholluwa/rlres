import 'package:atles/common/widgets/popover.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Sheet {
  static final Sheet _singleton = Sheet._internal();

  Sheet._internal();

  factory Sheet() {
    return _singleton;
  }

  static Future bottomDialog({
    required String title,
    required Widget content,
  }) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      elevation: 0,
      isScrollControlled: true,
      context: Get.context!,
      builder: (context) {
        return Popover(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.maxFinite,
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 17,),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: content,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}