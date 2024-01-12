import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_button.dart';
import 'bottom_sheet.dart';

void showDisconnect(VoidCallback onTap) async {
  await Sheet.bottomDialog(
    title: 'Logout?',
    content: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Text(
            'Are you sure you want to logout of the system?',
            style: TextStyle(
              color: Theme.of(Get.context!).hintColor,
          ),
          ),
          const SizedBox(
            height: 20,
          ),
          AppButton(
              onTap: onTap,
              text: 'Logout',
              buttonColor: Color(0xff13a866),
            height: 50,
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: (){
              Get.back();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xff13a866),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}