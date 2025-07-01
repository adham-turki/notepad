import 'package:flutter/material.dart';

class ResponsiveFormWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveFormWrapper({
    super.key,
    required this.child,
    this.maxWidth = 400,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;
    
    return Center(
      child: Container(
        width: isDesktop ? maxWidth : double.infinity,
        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),
        child: child,
      ),
    );
  }
}
