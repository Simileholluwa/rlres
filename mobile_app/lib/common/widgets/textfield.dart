import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final String? labelText;
  final TextInputType textInputType;
  final TextInputAction inputAction;
  final Color? focusedColor;
  final bool filled;
  final bool isHidden;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatter;
  final bool addBorder;
  const CustomTextField({
    Key? key,
    this.onSaved,
    this.addBorder = true,
    this.isHidden = false,
    this.filled = false,
    this.inputFormatter,
    this.validator,
    this.controller,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.labelText,
    this.textInputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.onTap, this.focusedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatter,
      onSaved: onSaved,
      validator: validator,
      obscureText: isHidden,
      keyboardType: textInputType,
      controller: controller,
      textInputAction: inputAction,
      onTap: onTap,
      onChanged: onChanged,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 17,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20,),
        filled: filled,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: Theme.of(context).hintColor
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        errorStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 15,
            color: Theme.of(context).colorScheme.error,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: addBorder
              ? BorderSide(
            color: Theme.of(context).dividerColor,
          )
              : const BorderSide(
            width: 0,
            color: Colors.transparent,
          ),
        ),
        fillColor: Theme.of(context).cardColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: addBorder
              ? BorderSide(
            color: focusedColor!,
            width: 1.0,
          )
              : const BorderSide(
            width: 0,
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
