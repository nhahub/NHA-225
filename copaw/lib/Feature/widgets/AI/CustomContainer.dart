import 'package:flutter/material.dart';
import 'package:copaw/utils/app_colors.dart';

class Customcontainer extends StatelessWidget {
  final double Width;
  final double? Height;
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final Color? BorderColor;
  final Color? sideColor; // ✅ new optional side color

  const Customcontainer({
    this.Height,
    required this.Width,
    this.child,
    this.margin,
    this.BorderColor,
    this.sideColor, // ✅ added
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: BorderColor ?? AppColors.grayColor.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      width: Width,
      height: Height,
      child: Row(
        children: [
          // ✅ Only show the side color if provided
          if (sideColor != null)
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: sideColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
            ),
          // ✅ Main content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
