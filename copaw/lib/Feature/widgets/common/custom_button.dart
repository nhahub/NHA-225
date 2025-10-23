import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool inverted; // ✅ لتبديل الألوان
  final IconData? icon; // ✅ لإضافة أيقونة (مثل +)
  final Color? color; // ✅ لون الزر الرئيسي
  final Color? textColor; // ✅ لون النص
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.inverted = false,
    this.icon,
    this.color,
    this.textColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = color ?? const Color.fromARGB(255, 24, 76, 165);
    final isInverted = inverted;

    final buttonBackground = isInverted ? Colors.white : primaryColor;
    final buttonTextColor = isInverted ? primaryColor : (textColor ?? Colors.white);
    final borderColor = isInverted ? primaryColor : Colors.transparent;

    return SizedBox(
      height: height ?? 55,
      width: width ?? MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor, width: 1.5),
          ),
          elevation: isInverted ? 0 : 2,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: buttonTextColor, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: buttonTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
