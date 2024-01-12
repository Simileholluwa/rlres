import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomepageState {
late TabController tabController;
RxBool isChecked = false.obs;
late FirebaseAuth auth;
RxBool selectedOption = false.obs;
RxList subDocumentName = [].obs;
RxList subDocumentUrl = [].obs;
RxList subDocumentSize = [].obs;
RxList plateNumbers = [].obs;
RxList time = [].obs;
RxList platesId = [].obs;
RxList dataFound = [].obs;
RxList imageUrls = [].obs;
RxInt selectedIndex = 0.obs;
RxInt selectedIndex2 = 0.obs;
RxBool isSelected = false.obs;
RxString appBarTitle = "R.L.R.E.S".obs;
RxString appBarTitle2 = "R.L.R.E.S".obs;
RxString documentId = ''.obs;
RxString documentId2 = ''.obs;
RxBool isLoading = false.obs;
late AnimationController animControl;
late Animation<double> animation;

}