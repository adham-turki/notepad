import 'package:flutter/material.dart';
import 'color_picker_data.dart';

class ColorPickerOption extends StatelessWidget {
  final Map<String, dynamic> colorData;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorPickerOption({
    super.key,
    required this.colorData,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = ColorPickerData.getColorFromHex(colorData['color']);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF6366F1).withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              colorData['icon'],
              size: 18,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                colorData['name'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected 
                      ? const Color(0xFF6366F1)
                      : Colors.grey.shade700,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                size: 18,
                color: Color(0xFF6366F1),
              ),
          ],
        ),
      ),
    );
  }
}