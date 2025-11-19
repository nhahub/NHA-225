import 'package:copaw/utils/app_colors.dart';
import 'package:flutter/material.dart';

typedef onValidator = String? Function(String?)?;

class CustomTextFormField extends StatelessWidget {
  final Color colorBorder;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final onValidator? validator;
  final TextInputType? keyBoardType;
  final bool obscureText;
  final String? obscuringCharacter;
  final int? maxLines;

  const CustomTextFormField({
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
    final width = MediaQuery.of(context).size.width * 0.9;
    final OutlineInputBorder defaultBorder = borderDecoration(colorBorder);
    final OutlineInputBorder errorBorder = borderDecoration(
      AppColors.warningColor,
    );

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
            spreadRadius: -6,
          ),
        ],
      ),
      child: TextFormField(
        maxLines: maxLines ?? 1,
        controller: controller,
        validator: validator,
        keyboardType: keyBoardType,
        obscureText: obscureText,
        cursorColor: AppColors.mainColor,
        obscuringCharacter: obscuringCharacter ?? '•',
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.whiteColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          enabledBorder: defaultBorder,
          focusedBorder: borderDecoration(AppColors.mainColor),
          errorBorder: errorBorder,
          focusedErrorBorder: errorBorder,
          hintText: hintText,
          hintStyle:
              hintStyle ??
              TextStyle(
                color: AppColors.grayColor.withOpacity(0.8),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
          labelText: labelText,
          labelStyle:
              labelStyle ??
              TextStyle(
                color: AppColors.textColor.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          errorStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor,
        ),
      ),
    );
  }

  OutlineInputBorder borderDecoration(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: color.withOpacity(0.8), width: 1.4),
    );
  }
}
