import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:atles/homepage/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/routes/names.dart';
import '../common/utils/firestore_ref.dart';
import '../common/utils/local_storage.dart';
import '../common/widgets/toast_message.dart';
import '../services/Authentication/auth_exceptions.dart';
import '../services/Authentication/auth_service.dart';
import 'package:http/http.dart' as http;

class HomepageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  HomepageController();

  final state = HomepageState();

  @override
  void onInit() {
    super.onInit();
    state.tabController = TabController(length: 3, vsync: this);
    state.auth = FirebaseAuth.instance;
    state.selectedIndex.value = 0;
    state.selectedIndex2.value = 0;
  }

  @override
  void onClose() {
    state.tabController.dispose();
    super.onClose();
  }

  void loadVideosForDocument(List videoUrls, List videoNames) {
    state.subDocumentUrl.assignAll(videoUrls);
    state.subDocumentName.assignAll(videoNames);
  }

  void loadImagesForDocument(List imageUrls, List time, List platesID, List plateNumber, List dataFound) {
    state.imageUrls.assignAll(imageUrls);
    state.time.assignAll(time);
    state.platesId.assignAll(platesID);
    state.plateNumbers.assignAll(plateNumber);
    state.dataFound.assignAll(dataFound);
  }

  void setInitialSelectedDocument(List videoUrls) {
    state.subDocumentUrl.assignAll(videoUrls);
  }

  Future<List> fetchInitialSelectedDocData() async {
    try {
      QuerySnapshot snapshot = await videoRF.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        var docData = snapshot.docs.first.data() as Map<String, dynamic>;
        var videoNames = docData['name'];
        state.subDocumentName.assignAll(videoNames);
        var videoUrls = docData['downloadUrl'];
        return videoUrls;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List> fetchInitialSelectedImageDocData() async {
    try {
      QuerySnapshot snapshot = await violatorsRF.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        var docData = snapshot.docs.first.data() as Map<String, dynamic>;
        var plateNumbers = docData['plate_numbers'];
        var dataFound = docData['data_found'];
        var time = docData['time'];
        var platesId = docData['plates_id'];
        var imageUrls = docData['image_url'];
        state.dataFound.assignAll(dataFound);
        state.platesId.assignAll(platesId);
        state.time.assignAll(time);
        state.plateNumbers.assignAll(plateNumbers);
        return imageUrls;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<String> loadImageLocally(String imageUrl) async {
    await saveImageThumbnailLocally(imageUrl);
    return StorageService.to.getString(imageUrl);
  }

  Future<Uint8List> generateImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final imageBytes = response.bodyBytes;
    return imageBytes;
  }

  Future<Uint8List> generateThumbnail(String videoUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 120,
      quality: 100,
    );
    return thumbnail!;
  }

  Future<String> loadThumbnailLocally(String videoUrl) async {
    await saveThumbnailLocally(videoUrl);
    return StorageService.to.getString(videoUrl);
  }

  Future<void> saveThumbnailLocally(String videoUrl) async {
    final thumbnailBase64 = StorageService.to.getString(videoUrl);

    if (thumbnailBase64 == '') {
      final uint8list = await generateThumbnail(videoUrl);

      if (uint8list.isNotEmpty) {
        final thumbnailBase64 = base64Encode(uint8list);
        await StorageService.to.setString(videoUrl, thumbnailBase64);
      }
    }
  }

  Future<void> saveImageThumbnailLocally(String imageUrl) async {
    final thumbnailBase64 = StorageService.to.getString(imageUrl);

    if (thumbnailBase64 == '') {
      final uint8list = await generateImage(imageUrl);

      if (uint8list.isNotEmpty) {
        final thumbnailBase64 = base64Encode(uint8list);
        await StorageService.to.setString(imageUrl, thumbnailBase64);
      }
    }
  }

  String parseDateFromFolderName(String folderName) {
    RxString month = ''.obs;
    final parts = folderName.split('-');
    if (parts.length >= 3) {
      switch (parts[1]) {
        case '01':
          month.value = 'Jan.';
          break;
        case '02':
          month.value = 'Feb.';
          break;
        case '03':
          month.value = 'Mar.';
          break;
        case '04':
          month.value = 'Apr.';
          break;
        case '05':
          month.value = 'May';
          break;
        case '06':
          month.value = 'June';
          break;
        case '07':
          month.value = 'July';
          break;
        case '08':
          month.value = 'Aug.';
          break;
        case '09':
          month.value = 'Sep.';
          break;
        case '10':
          month.value = 'Oct.';
          break;
        case '11':
          month.value = 'Nov.';
          break;
        case '12':
          month.value = 'Dec.';
          break;
      }
      return '${month.value} ${parts[2]}, ${parts[0]}';
    } else {
      return 'Captured';
    }
  }


  signOut() async {
    try {
      await AuthService.firebase().logOut();
      Get.offAllNamed(AppRoutes.login);
      message('Signed out successfully.', isError: false);
    } on UserNotLoggedInAuthException {
      message('You are currently not signed in.');
    }
  }

  String parseVideoName(String videoName) {
    RxString amPm = ''.obs;
    final parts = videoName.split('-');
    if (int.tryParse(parts[0])! < 12) {
      amPm.value = 'AM';
    } else if (int.tryParse(parts[0])! >= 12) {
      amPm.value = 'PM';
    }
    return '${parts[0]}:${parts[1]}:${parts[2]} ${amPm.value}';
  }
}
