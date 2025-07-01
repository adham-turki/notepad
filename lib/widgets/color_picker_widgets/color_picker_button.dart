import 'package:flutter/material.dart';
import 'color_picker_data.dart';

class ColorPickerButton extends StatelessWidget {
  final String selectedColor;
  final Color iconColor;
  final bool isOpen;

  const ColorPickerButton({
    super.key,
    required this.selectedColor,
    required this.iconColor,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: ColorPickerData.getColorFromHex(selectedColor),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            ColorPickerData.getSelectedColorIcon(selectedColor),
            size: 16,
            color: iconColor,
          ),
          const SizedBox(width: 4),
          AnimatedRotation(
            turns: isOpen ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}