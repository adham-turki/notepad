import 'package:flutter/material.dart';
import 'color_picker_data.dart';
import 'color_picker_option.dart';

class ColorPickerOverlay extends StatelessWidget {
  final Offset position;
  final String selectedColor;
  final Animation<double> fadeAnimation;
  final Animation<double> expandAnimation;
  final Function(String) onColorSelected;

  const ColorPickerOverlay({
    super.key,
    required this.position,
    required this.selectedColor,
    required this.fadeAnimation,
    required this.expandAnimation,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Material(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: expandAnimation,
            alignment: Alignment.topRight,
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  _buildColorOptions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.palette,
            size: 18,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 8),
          Text(
            'Choose Color',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: ColorPickerData.colors.map((colorData) {
          return ColorPickerOption(
            colorData: colorData,
            isSelected: selectedColor == colorData['color'],
            onTap: () => onColorSelected(colorData['color']),
          );
        }).toList(),
      ),
    );
  }
}