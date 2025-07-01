import 'package:flutter/material.dart';
import 'color_dropdown_picker.dart';

class NoteEditorAppBar extends StatelessWidget {
  final bool isNewNote;
  final bool isLoading;
  final bool hasChanges;
  final String selectedColor;
  final Color textColor;
  final VoidCallback onSave;
  final Function(String) onColorChanged;

  const NoteEditorAppBar({
    super.key,
    required this.isNewNote,
    required this.isLoading,
    required this.hasChanges,
    required this.selectedColor,
    required this.textColor,
    required this.onSave,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = textColor == Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isDark ? 0.1 : 0.7),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              isNewNote ? 'New Note' : 'Edit Note',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Color picker dropdown
          Stack(
            children: [
              ColorDropdownPicker(
                selectedColor: selectedColor,
                onColorSelected: onColorChanged,
                iconColor: textColor,
              ),
              if (hasChanges)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
          // Save button
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton.icon(
              onPressed: isLoading ? null : onSave,
              icon: isLoading 
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.save_outlined, color: Colors.white, size: 18),
              label: Text(
                isLoading ? 'Saving...' : 'Save',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
