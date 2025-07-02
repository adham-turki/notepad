import 'package:flutter/material.dart';

class ResponsiveFormWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  const ResponsiveFormWrapper({
    super.key,
    required this.child,
    this.maxWidth = 400,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Define breakpoints
    final isTablet = screenWidth > 768 && screenWidth <= 1024;
    final isDesktop = screenWidth > 1024;
    final isMobile = screenWidth <= 768;
    
    // Calculate responsive padding
    EdgeInsets responsivePadding = padding ?? EdgeInsets.symmetric(
      horizontal: isMobile ? 16.0 : (isTablet ? 32.0 : 48.0),
      vertical: isMobile ? 16.0 : 24.0,
    );
    
    // Calculate responsive width
    double containerWidth;
    if (isDesktop) {
      containerWidth = maxWidth;
    } else if (isTablet) {
      containerWidth = screenWidth * 0.7; // 70% of screen width on tablet
    } else {
      containerWidth = double.infinity; // Full width on mobile
    }
    
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: containerWidth,
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              minHeight: isMobile ? 0 : screenHeight * 0.6,
            ),
            margin: isMobile 
              ? EdgeInsets.zero 
              : const EdgeInsets.symmetric(vertical: 20.0),
            padding: responsivePadding,
            child: child,
          ),
        ),
      ),
    );
  }
}