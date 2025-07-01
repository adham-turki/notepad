import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;
  final Animation<double> fadeAnimation;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return FadeTransition(
      opacity: fadeAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Previous button
            _buildPageButton(
              icon: Icons.chevron_left,
              onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
              isEnabled: currentPage > 1,
            ),
            
            const SizedBox(width: 16),
            
            // Page indicators
            Row(
              mainAxisSize: MainAxisSize.min,
              children: _buildPageIndicators(),
            ),
            
            const SizedBox(width: 16),
            
            // Next button
            _buildPageButton(
              icon: Icons.chevron_right,
              onTap: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
              isEnabled: currentPage < totalPages,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isEnabled 
              ? const Color(0xFF6366F1).withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isEnabled 
              ? const Color(0xFF6366F1)
              : Colors.grey.shade400,
          size: 20,
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicators() {
    List<Widget> indicators = [];
    
    // Show max 5 page indicators
    int startPage = (currentPage - 2).clamp(1, totalPages);
    int endPage = (startPage + 4).clamp(1, totalPages);
    
    // Adjust start if we're near the end
    if (endPage - startPage < 4) {
      startPage = (endPage - 4).clamp(1, totalPages);
    }

    for (int i = startPage; i <= endPage; i++) {
      indicators.add(_buildPageIndicator(i));
      if (i < endPage) {
        indicators.add(const SizedBox(width: 8));
      }
    }

    return indicators;
  }

  Widget _buildPageIndicator(int page) {
    final isActive = page == currentPage;
    
    return GestureDetector(
      onTap: () => onPageChanged(page),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isActive ? 32 : 24,
        height: isActive ? 32 : 24,
        decoration: BoxDecoration(
          color: isActive 
              ? const Color(0xFF6366F1)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(isActive ? 16 : 12),
        ),
        child: Center(
          child: Text(
            '$page',
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey.shade600,
              fontSize: isActive ? 14 : 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
