import 'package:copaw/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final String dateText;
  final VoidCallback onTap;

  const DatePickerField({
    super.key,
    required this.label,
    required this.dateText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.015,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grayColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.textColor),
                 SizedBox(width: width * 0.03),
                Text(
                  dateText,
                  style: TextStyle(fontSize: 14, color: AppColors.textColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
