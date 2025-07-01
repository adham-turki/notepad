import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/note.dart';
import '../../services/database_helper.dart';
import '../../widgets/note_editor_app_bar.dart';
import '../../widgets/note_input_fields.dart';

class NoteEditorScreen extends StatefulWidget {
  final int userId;
  final Note? note;

  const NoteEditorScreen({
    super.key,
    required this.userId,
    this.note,
  });

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen>
    with TickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _titleFocusNode = FocusNode();
  final _contentFocusNode = FocusNode();
  
  String _selectedColor = '#FFFFFF';
  bool _isLoading = false;
  bool _hasChanges = false;
  
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _initializeNote();
    _slideController.forward();
  }

  void _initializeNote() {
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = widget.note!.color;
    }
    
    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
    
    // Auto-focus title for new notes
    if (widget.note == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _titleFocusNode.requestFocus();
      });
    }
  }

  void _onTextChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_titleController.text.trim().isEmpty && _contentController.text.trim().isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _isLoading = true);
    
    // Haptic feedback
    HapticFeedback.lightImpact();

    try {
      if (widget.note == null) {
        // Create new note
        final note = Note(
          title: _titleController.text.trim().isEmpty 
              ? 'Untitled Note' 
              : _titleController.text.trim(),
          content: _contentController.text.trim(),
          userId: widget.userId,
          color: _selectedColor,
        );
        await DatabaseHelper.instance.createNote(note);
      } else {
        // Update existing note
        final updatedNote = widget.note!.copyWith(
          title: _titleController.text.trim().isEmpty 
              ? 'Untitled Note' 
              : _titleController.text.trim(),
          content: _contentController.text.trim(),
          color: _selectedColor,
        );
        await DatabaseHelper.instance.updateNote(updatedNote);
      }

      if (mounted) {
        // Success haptic feedback
        HapticFeedback.mediumImpact();
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Text('Failed to save note'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Color _getColorFromHex(String hexColor) {
    return Color(int.parse(hexColor.substring(1), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getColorFromHex(_selectedColor);
    final isDark = backgroundColor.computeLuminance() < 0.5;
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.white60 : Colors.black45;

    return SlideTransition(
      position: _slideAnimation,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              NoteEditorAppBar(
                isNewNote: widget.note == null,
                isLoading: _isLoading,
                hasChanges: _hasChanges,
                selectedColor: _selectedColor,
                textColor: textColor,
                onSave: _saveNote,
                onColorChanged: (color) => setState(() => _selectedColor = color),
              ),
              NoteInputFields(
                titleController: _titleController,
                contentController: _contentController,
                titleFocusNode: _titleFocusNode,
                contentFocusNode: _contentFocusNode,
                textColor: textColor,
                hintColor: hintColor,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
