import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  final List<Map<String, dynamic>> _colors = const [
    {'color': '#FFFFFF', 'name': 'White', 'icon': Icons.brightness_7},
    {'color': '#FEF3C7', 'name': 'Yellow', 'icon': Icons.wb_sunny},
    {'color': '#DBEAFE', 'name': 'Blue', 'icon': Icons.water_drop},
    {'color': '#D1FAE5', 'name': 'Green', 'icon': Icons.eco},
    {'color': '#FCE7F3', 'name': 'Pink', 'icon': Icons.favorite},
    {'color': '#E0E7FF', 'name': 'Lavender', 'icon': Icons.local_florist},
    {'color': '#FED7D7', 'name': 'Coral', 'icon': Icons.waves},
    {'color': '#F3E8FF', 'name': 'Purple', 'icon': Icons.auto_awesome},
  ];

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

  Color _getColorFromHex(String hexColor) {
    return Color(int.parse(hexColor.substring(1), radix: 16) + 0xFF000000);
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    setState(() {
      _isOpen = true;
    });
    
    _animationController.forward();
    _createOverlay();
  }

  void _closeDropdown() {
    setState(() {
      _isOpen = false;
    });
    
    _animationController.reverse().then((_) {
      _removeOverlay();
    });
  }

  void _createOverlay() {
    _removeOverlay();
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 8,
        child: Material(
          color: Colors.transparent,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _expandAnimation,
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
                    // Header
                    Container(
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
                    ),
                    
                    // Color options
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: _colors.map((colorData) {
                          final isSelected = widget.selectedColor == colorData['color'];
                          final color = _getColorFromHex(colorData['color']);
                          
                          return GestureDetector(
                            onTap: () => _selectColor(colorData['color']),
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
                                        fontWeight: isSelected 
                                            ? FontWeight.w600 
                                            : FontWeight.w400,
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
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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

  IconData _getSelectedColorIcon() {
    final selectedColorData = _colors.firstWhere(
      (color) => color['color'] == widget.selectedColor,
      orElse: () => _colors[0],
    );
    return selectedColorData['icon'];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDropdown,
      child: Container(
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
                color: _getColorFromHex(widget.selectedColor),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              _getSelectedColorIcon(),
              size: 16,
              color: widget.iconColor,
            ),
            const SizedBox(width: 4),
            AnimatedRotation(
              turns: _isOpen ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: widget.iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
