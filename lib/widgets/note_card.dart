// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/note.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final Function(Note) onTogglePin; // New callback for pin toggle

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.onTogglePin,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getColorFromHex(String hexColor) {
    return Color(int.parse(hexColor.substring(1), radix: 16) + 0xFF000000);
  }

  Color _getDarkerColor(Color color) {
    return Color.fromRGBO(
      (color.red * 0.9).round(),
      (color.green * 0.9).round(),
      (color.blue * 0.9).round(),
      1.0,
    );
  }

  void _togglePin() {
    HapticFeedback.lightImpact();
    widget.onTogglePin(widget.note);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 768;
    
    final cardColor = _getColorFromHex(widget.note.color);
    final isDark = cardColor.computeLuminance() < 0.5;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;

    // Responsive sizing
    final double borderRadius = isMobile ? 16 : 20;
    final double horizontalPadding = isMobile ? 16 : 20;
    final double verticalPadding = isMobile ? 16 : 20;
    final double titleFontSize = isMobile ? 16 : 18;
    final double contentFontSize = isMobile ? 13 : 14;
    final double dateFontSize = isMobile ? 10 : 11;
    final int maxTitleLines = isMobile ? 1 : 2;
    final int maxContentLines = isMobile ? 3 : 4;

    return MouseRegion(
      onEnter: (_) => !isMobile ? _animationController.forward() : null,
      onExit: (_) => !isMobile ? _animationController.reverse() : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isMobile ? 1.0 : _scaleAnimation.value, // Disable scale on mobile
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cardColor,
                      _getDarkerColor(cardColor),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: cardColor.withOpacity(isMobile ? 0.15 : 0.2),
                      blurRadius: isMobile ? 6 : 8,
                      offset: Offset(0, isMobile ? 3 : 4),
                    ),
                  ],
                  border: widget.note.isPinned
                      ? Border.all(
                          color: const Color(0xFFFFD700), // Gold border for pinned
                          width: isMobile ? 1.5 : 2,
                        )
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Stack(
                    children: [
                      // Background pattern - smaller on mobile
                      if (!isMobile) ...[
                        Positioned(
                          top: -20,
                          right: -20,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -30,
                          left: -30,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                        ),
                      ] else ...[
                        // Smaller background elements for mobile
                        Positioned(
                          top: -10,
                          right: -10,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                        ),
                      ],
                      
                      // Pinned indicator star
                      if (widget.note.isPinned)
                        Positioned(
                          top: isMobile ? 8 : 12,
                          left: isMobile ? 8 : 12,
                          child: Container(
                            padding: EdgeInsets.all(isMobile ? 4 : 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFD700).withOpacity(0.3),
                                  blurRadius: isMobile ? 3 : 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.star,
                              size: isMobile ? 12 : 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      
                      // Content
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.note.title,
                                    style: TextStyle(
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                      height: 1.2,
                                    ),
                                    maxLines: maxTitleLines,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
                                  ),
                                  child: PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_vert,
                                      size: isMobile ? 16 : 18,
                                      color: textColor,
                                    ),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        widget.onTap();
                                      } else if (value == 'delete') {
                                        widget.onDelete();
                                      } else if (value == 'pin') {
                                        _togglePin();
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'pin',
                                        child: Row(
                                          children: [
                                            Icon(
                                              widget.note.isPinned 
                                                  ? Icons.star 
                                                  : Icons.star_border,
                                              color: widget.note.isPinned 
                                                  ? const Color(0xFFFFD700) 
                                                  : const Color(0xFF6366F1),
                                              size: isMobile ? 18 : 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              widget.note.isPinned ? 'Unpin' : 'Pin',
                                              style: TextStyle(
                                                color: widget.note.isPinned 
                                                    ? const Color(0xFFFFD700) 
                                                    : const Color(0xFF6366F1),
                                                fontSize: isMobile ? 14 : 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit_outlined, 
                                              color: const Color(0xFF6366F1),
                                              size: isMobile ? 18 : 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Edit',
                                              style: TextStyle(fontSize: isMobile ? 14 : 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete_outline, 
                                              color: Colors.red,
                                              size: isMobile ? 18 : 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: isMobile ? 14 : 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            // Content preview - Always show this section
                            SizedBox(height: isMobile ? 8 : 12),
                            Text(
                              widget.note.content.isNotEmpty 
                                  ? widget.note.content
                                  : 'No content',
                              style: TextStyle(
                                fontSize: contentFontSize,
                                color: widget.note.content.isNotEmpty 
                                    ? subtitleColor 
                                    : subtitleColor.withOpacity(0.7),
                                height: 1.4,
                                fontStyle: widget.note.content.isEmpty 
                                    ? FontStyle.italic 
                                    : FontStyle.normal,
                              ),
                              maxLines: maxContentLines,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            SizedBox(height: isMobile ? 12 : 16),
                            
                            // Footer with date and star button
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 6 : 8,
                                    vertical: isMobile ? 3 : 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                                  ),
                                  child: Text(
                                    _formatDate(widget.note.updatedAt),
                                    style: TextStyle(
                                      fontSize: dateFontSize,
                                      color: textColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                
                                // Star/Pin button
                                GestureDetector(
                                  onTap: _togglePin,
                                  child: Container(
                                    padding: EdgeInsets.all(isMobile ? 4 : 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
                                    ),
                                    child: Icon(
                                      widget.note.isPinned ? Icons.star : Icons.star_border,
                                      size: isMobile ? 14 : 16,
                                      color: widget.note.isPinned 
                                          ? const Color(0xFFFFD700) 
                                          : textColor,
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(width: 8),
                                
                                // Edit button - hidden on mobile, shown on hover for desktop
                                if (!isMobile)
                                  AnimatedOpacity(
                                    opacity: _scaleAnimation.value > 1.01 ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 150),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.edit_outlined,
                                        size: 14,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}