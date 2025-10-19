import 'package:copaw/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A reusable date picker field widget
/// Displays a label, the selected date, and a calendar icon.
/// Opens a date picker when tapped.
class DatePickerField extends StatefulWidget {
  final String label;
  final String dateText;
  final ValueChanged<String> onDateSelected; // callback to send picked date back

  const DatePickerField({
    super.key,
    required this.label,
    required this.dateText,
    required this.onDateSelected,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // current date
      firstDate: DateTime.now(), // can't pick past date
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Format date to readable text
      final formattedDate = DateFormat('MMM dd, yyyy').format(pickedDate);
      widget.onDateSelected(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _selectDate(context),
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
                const Icon(Icons.calendar_today, color: AppColors.textColor),
                SizedBox(width: width * 0.03),
                Text(
                  widget.dateText,
                  style: const TextStyle(fontSize: 14, color: AppColors.textColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
