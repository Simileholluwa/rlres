import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AndroidBottomNav extends StatelessWidget {
  final Widget child;
  final FlexSystemNavBarStyle systemNavBarStyle;
  const AndroidBottomNav({Key? key, required this.child, this.systemNavBarStyle = FlexSystemNavBarStyle.scaffoldBackground}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        systemNavBarStyle: systemNavBarStyle,
        useDivider: false,
        opacity: 1,
      ),
      child: child,
    );
  }
}
