import 'package:flutter/material.dart';
import 'package:copaw/utils/app_colors.dart';

class CustomMultipleSelectChoices extends StatefulWidget {
  final List<String> options;              // list of choices
  final List<String>? initiallySelected;   // pre-selected options
  final Function(List<String>) onSelectionChanged; // callback

  const CustomMultipleSelectChoices({
    super.key,
    required this.options,
    required this.onSelectionChanged,
    this.initiallySelected,
  });

  @override
  State<CustomMultipleSelectChoices> createState() =>
      _CustomMultipleSelectChoicesState();
}

class _CustomMultipleSelectChoicesState
    extends State<CustomMultipleSelectChoices> {
  late List<String> selected;

  @override
  void initState() {
    super.initState();
    // ✅ Create a *copy* so we can safely modify it
    selected = List<String>.from(widget.initiallySelected ?? []);
  }

  void toggleSelection(String option) {
    setState(() {
      if (selected.contains(option)) {
        selected.remove(option);
      } else {
        selected.add(option);
      }
    });
    widget.onSelectionChanged(List<String>.from(selected));
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.options.map((option) {
        final isSelected = selected.contains(option);
        return ChoiceChip(
          label: Text(
            option,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.grayColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          selected: isSelected,
          selectedColor: AppColors.mainColor,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected
                  ? AppColors.mainColor
                  : AppColors.grayColor.withOpacity(0.3),
            ),
          ),
          onSelected: (_) => toggleSelection(option),
        );
      }).toList(),
    );
  }
}
