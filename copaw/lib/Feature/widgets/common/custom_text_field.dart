import 'package:copaw/utils/app_colors.dart';
import 'package:flutter/material.dart';

typedef onValidator = String? Function(String?)?;

class CustomTextFormField extends StatelessWidget {
  Color colorBorder;
  String? hintText;
  TextStyle? hintStyle;
  String? labelText;
  TextStyle? labelStyle;
  Widget? prefixIcon;
  Widget? suffixIcon;
  TextEditingController controller;
  onValidator? validator;
  TextInputType? keyBoardType;
  bool obscureText;
  String? obscuringCharacter;
  int? maxLines;


  CustomTextFormField({
    super.key,
    this.colorBorder = AppColors.grayColor,
    this.hintText,
    this.hintStyle,
    this.labelText,
    this.labelStyle,
    this.prefixIcon,
    this.suffixIcon,
    required this.controller,
    this.validator,
    this.keyBoardType = TextInputType.text,
    this.obscureText = false,
    this.obscuringCharacter,
    this.maxLines,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextFormField(
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
          enabledBorder: borderDecoration(colorBorder: colorBorder),
          focusedBorder: borderDecoration(colorBorder: colorBorder),
          errorBorder: borderDecoration(colorBorder: AppColors.warningColor),
          focusedErrorBorder: borderDecoration(
            colorBorder: AppColors.warningColor,
          ),
          hintText: hintText,
          hintStyle:
              hintStyle ??
              TextStyle(
                color: AppColors.grayColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
          labelText: labelText,
          labelStyle:
              labelStyle ??
              TextStyle(
                color: AppColors.grayColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
          prefixIcon: prefixIcon,
          suffix: suffixIcon,
          errorStyle: TextStyle(
            color: AppColors.warningColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        keyboardType: keyBoardType,
        obscureText: obscureText,
        controller: controller,
        validator: validator,
        cursorColor: AppColors.mainColor,
        obscuringCharacter: obscuringCharacter ?? '.',
      ),
    );
  }

  OutlineInputBorder borderDecoration({required Color colorBorder}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: colorBorder, width: 2),
    );
  }
}
