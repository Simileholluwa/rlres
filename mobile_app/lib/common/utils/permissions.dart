import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static List<Permission> androidPermissions = <Permission>[
    Permission.videos,
    Permission.photos
  ];

  /// ios
  static List<Permission> iosPermissions = <Permission>[
    Permission.storage,
    Permission.videos,
    Permission.photos
  ];

  static Future<Map<Permission, PermissionStatus>> requestAll() async {
    if (Platform.isIOS) {
      return await iosPermissions.request();
    }
    return await androidPermissions.request();
  }

  static Future<Map<Permission, PermissionStatus>> request(
      Permission permission) async {
    final List<Permission> permissions = <Permission>[permission];
    return await permissions.request();
  }

  static bool isDenied(Map<Permission, PermissionStatus> result) {
    var isDenied = false;
    result.forEach((key, value) {
      if (value == PermissionStatus.denied) {
        isDenied = true;
        return;
      }
    });
    return isDenied;
  }

  // static void showDeniedDialog(BuildContext context) {
  //   HDialog.show(
  //       context: context,
  //       title: '权限申请异常',
  //       content: '请在【应用信息】-【权限管理】中，开启全部所需权限，以正常使用惠爆单功能',
  //       options: <DialogAction>[
  //         DialogAction(text: '去设置', onPressed: () => openAppSettings())
  //       ]);
  // }

  static Future<bool> checkGranted(Permission permission) async {
    PermissionStatus storageStatus = await permission.status;
    if (storageStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}