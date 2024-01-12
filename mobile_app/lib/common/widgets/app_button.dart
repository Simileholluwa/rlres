import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final String text;
  final bool addBorder;
  final Color? iconColor;
  final Color? buttonColor;
  final bool isLoading;
  final Color? textColor;
  final Color? loadingColor;
  final double? radius;
  const AppButton({
    Key? key,
    required this.onTap,
    this.width = double.maxFinite,
    this.height = 80,
    this.radius = 10,
    required this.text,
    this.textColor = Colors.white,
    this.addBorder = false,
    this.iconColor,
    this.isLoading = false,
    this.buttonColor,
    this.loadingColor = const Color(0xff13a866),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        splashColor: Colors.white.withOpacity(.2),
        onTap: isLoading == false ? onTap : () {},
        borderRadius: BorderRadius.circular(15),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 500,
          ),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: isLoading == false
                ? buttonColor
                : Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(radius!),
            border: addBorder ? Border.all(color: Theme.of(context).hintColor) : null,
          ),
          child: isLoading == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingAnimationWidget.prograssiveDots(
                      color: loadingColor!,
                      size: 70,
                    ),
                  ],
                )
              : Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: textColor,
                        ),
                    child: Text(
                      text,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
