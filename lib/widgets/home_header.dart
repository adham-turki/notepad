// ignore_for_file: deprecated_member_use, sort_child_properties_last

import 'package:flutter/material.dart';
import '../models/user.dart';
import 'home_header_content.dart';
import 'home_header_stats.dart';

class HomeHeader extends StatelessWidget {
  final User? currentUser;
  final int notesCount;
  final int todayNotesCount;
  final VoidCallback onLogout;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const HomeHeader({
    super.key,
    required this.currentUser,
    required this.notesCount,
    required this.todayNotesCount,
    required this.onLogout,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6366F1),
                Color(0xFF8B5CF6),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              HomeHeaderContent(
                currentUser: currentUser,
                onLogout: onLogout,
              ),
              const SizedBox(height: 20),
              HomeHeaderStats(
                notesCount: notesCount,
                todayNotesCount: todayNotesCount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
