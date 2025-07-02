import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color_picker_widgets/color_picker_overlay.dart';
import 'color_picker_widgets/color_picker_button.dart';

class ColorDropdownPicker extends StatefulWidget {
  final String selectedColor;
  final Function(String) onColorSelected;
  final Color iconColor;

  const ColorDropdownPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.iconColor = Colors.black,
  });

  @override
  State<ColorDropdownPicker> createState() => _ColorDropdownPickerState();
}

class _ColorDropdownPickerState extends State<ColorDropdownPicker>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    setState(() => _isOpen = true);
    _animationController.forward();
    _createOverlay();
  }

  void _closeDropdown() {
    setState(() => _isOpen = false);
    _animationController.reverse().then((_) => _removeOverlay());
  }

  void _createOverlay() {
    _removeOverlay();
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    
    _overlayEntry = OverlayEntry(
      builder: (context) => ColorPickerOverlay(
        position: Offset(offset.dx, offset.dy + size.height + 8),
        selectedColor: widget.selectedColor,
        fadeAnimation: _fadeAnimation,
        expandAnimation: _expandAnimation,
        onColorSelected: _selectColor,
      ),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectColor(String colorHex) {
    widget.onColorSelected(colorHex);
    HapticFeedback.selectionClick();
    _closeDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDropdown,
      child: ColorPickerButton(
        selectedColor: widget.selectedColor,
        iconColor: widget.iconColor,
        isOpen: _isOpen,
      ),
    );
  }
}