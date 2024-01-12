import 'package:atles/common/widgets/toast_message.dart';
import 'package:flutter/cupertino.dart';

class ShouldExit extends StatelessWidget {
  final Widget child;
  const ShouldExit({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    DateTime _lastExitTime = DateTime.now();
    return WillPopScope(
        child: child,
      onWillPop: () async {
        if (DateTime.now().difference(_lastExitTime) >=
            const Duration(seconds: 2)) {
          message(
            'Press the back button again to exit app.',
            isInfo: true,
            isError: false
          );
          _lastExitTime = DateTime.now();
          return false;
        } else {
          return true;
        }
      },
    );
  }
}
