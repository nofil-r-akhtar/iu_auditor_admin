import 'package:flutter/material.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/const/enums.dart';

class AppTextField extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? placeholder;
  final Color? backgroundColor;
  final TextEditingController textController;
  final bool? isSecured;
  final double? fontSize;
  final FontFamily? fontFamily;
  final TextInputType? keyboardType;
  final TextInputAction? submitLabel;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final bool? isTextFieldEnabled;
  final Color? placeholderColor;
  final InputBorder? outlineBorder;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final bool obscureText;
  final double textFieldPadding;
  final int? minLine;
  final int? maxLine;
  final Function()? onTap;
  const AppTextField({
  this.prefixIcon,
      this.suffixIcon,
      this.placeholder,
      this.backgroundColor = bgColor,
      required this.textController,
      this.isSecured = false,
      this.fontSize = 16.0,
      this.fontFamily =
          FontFamily.inter, // replace with your actual font family
      this.keyboardType = TextInputType.text,
      this.submitLabel = TextInputAction.next,
      this.onChanged,
      this.onFieldSubmitted,
      this.validator,
      this.isTextFieldEnabled = true,
      this.placeholderColor = primaryColor,
      this.outlineBorder = InputBorder.none, 
      // = const OutlineInputBorder(
      //   borderSide: BorderSide(
      //       color: primaryColor, width: 0.25, style: BorderStyle.none),
      // ),
      this.focusedBorder = InputBorder.none,
      // = const OutlineInputBorder(
      //   borderSide: BorderSide(color: primaryColor, width: 0.25),
      // ),
      this.enabledBorder = InputBorder.none,
      //  = const OutlineInputBorder(
      //   borderSide: BorderSide(
      //       color: primaryColor, width: 0.1, style: BorderStyle.none),
      // ),
      this.obscureText = false,
      this.textFieldPadding = 0,
      this.minLine,
      this.maxLine,
      this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      bgColor: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 8),
      borderRadius: BorderRadius.circular(12),
      alignment: Alignment.topCenter,
      child: TextFormField(
        maxLines: (minLine ?? 1) > 1 ? null : 1,
        onTap: onTap,
        minLines: minLine,
        controller: textController,
        keyboardType: keyboardType,
        textInputAction: submitLabel,
        enabled: isTextFieldEnabled,
        obscureText: obscureText,
        style: TextStyle(
            fontSize: fontSize,
            height: 1.5,
            fontFamily: fontFamily.toString(),
            fontWeight: FontWeight.w400,
            color: primaryColor),
        cursorColor: placeholderColor,
        onChanged: onChanged,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          border: outlineBorder,
          focusedBorder: focusedBorder,
          enabledBorder: enabledBorder,
          // labelText: placeholder,
          // labelStyle: TextStyle(fontSize: 14, color: placeholderColor, fontWeight: FontWeight.w400, fontFamily: fontFamily.toString()),
          // hintStyle: TextStyle(color: placeholderColor),
          hintText: placeholder,
          hintStyle: TextStyle(color: placeholderColor),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
        validator: validator ?? (_) => 'TextField is not Empty',
        textAlignVertical: TextAlignVertical.center,
      ),
    ); 
  }
}