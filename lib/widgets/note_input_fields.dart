import 'package:flutter/material.dart';

class NoteInputFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final FocusNode titleFocusNode;
  final FocusNode contentFocusNode;
  final Color textColor;
  final Color hintColor;
  final bool isDark;

  const NoteInputFields({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.titleFocusNode,
    required this.contentFocusNode,
    required this.textColor,
    required this.hintColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Title Field
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(isDark ? 0.1 : 0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: titleController,
                focusNode: titleFocusNode,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Note title...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: hintColor,
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Content Field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(isDark ? 0.1 : 0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: contentController,
                  focusNode: contentFocusNode,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    height: 1.5,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Start writing your thoughts...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: hintColor,
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
