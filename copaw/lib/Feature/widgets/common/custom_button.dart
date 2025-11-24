import 'package:copaw/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool inverted;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
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
    final primaryColor = color ?? AppColors.mainColor;
    final isDisabled = onPressed == null;
    final radius = BorderRadius.circular(16);
    final gradient = LinearGradient(
      colors: [
        primaryColor,
        Color.lerp(primaryColor, AppColors.whiteColor, 0.25)!,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final backgroundColor = inverted
        ? AppColors.whiteColor
        : (isDisabled ? AppColors.grayColor.withOpacity(0.4) : null);

    final textStyle = TextStyle(
      color: inverted
          ? primaryColor
          : (textColor ??
                AppColors.whiteColor.withOpacity(isDisabled ? 0.8 : 1)),
      fontSize: 16,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w600,
    );

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isDisabled ? 0.6 : 1,
      child: SizedBox(
        height: height ?? 56,
       width: width ?? MediaQuery.of(context).size.width * 0.89,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              gradient: inverted || isDisabled ? null : gradient,
              color: backgroundColor,
              borderRadius: radius,
              border: Border.all(
                color: inverted ? primaryColor : Colors.transparent,
                width: 1.3,
              ),
              boxShadow: [
                if (!inverted && !isDisabled)
                  BoxShadow(
                    color: primaryColor.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                    spreadRadius: -6,
                  ),
              ],
            ),
            child: InkWell(
              onTap: onPressed,
              borderRadius: radius,
              highlightColor: primaryColor.withOpacity(0.08),
              splashFactory: InkRipple.splashFactory,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: textStyle.color, size: 20),
                    const SizedBox(width: 10),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
