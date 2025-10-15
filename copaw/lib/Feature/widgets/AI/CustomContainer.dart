import 'package:flutter/material.dart';
import 'package:copaw/utils/app_colors.dart';

class Customcontainer extends StatelessWidget {
  final double Width;
  final double? Height;
  final Widget? child;

  const Customcontainer({
     this.Height,
    required this.Width,
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.grayColor.withOpacity(0.3)),
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
          child: child,
        ),
      ),
    );
  }
}
