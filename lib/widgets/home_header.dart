// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../screens/profile/profile_screen.dart';

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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Left side - Greeting
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentUser?.name ?? 'User',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Center - Stats
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStatItem(
                      icon: Icons.note_alt_outlined,
                      value: '$notesCount',
                      label: 'Notes',
                      
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      width: 1,
                      height: 30,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    _buildStatItem(
                      icon: Icons.today_outlined,
                      value: todayNotesCount.toString(),
                      label: 'Today',
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Right side - Profile with Active Indicator
              _buildProfileMenu(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
  required IconData icon,
  required String value,
  required String label,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        color: Colors.grey.shade600, // Adjusted icon color for consistency
        size: 16,
      ),
      const SizedBox(height: 2),
      Text(
        value,
        style: TextStyle(
          color: Colors.grey.shade700, // Darker gray for better readability
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade600, // Slightly lighter gray for label
          fontSize: 10,
        ),
      ),
    ],
  );
}

  Widget _buildProfileMenu(BuildContext context) {
    return PopupMenuButton<String>(
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF6366F1),
              child: Text(
                currentUser?.name.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Active indicator (green dot)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981), // Green color
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onSelected: (value) {
        if (value == 'profile') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProfileScreen(user: currentUser!),
            ),
          );
        } else if (value == 'logout') {
          onLogout();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person_outlined, color: Color(0xFF6366F1)),
              SizedBox(width: 12),
              Text('View Profile'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_outlined, color: Colors.red),
              SizedBox(width: 12),
              Text('Logout', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}