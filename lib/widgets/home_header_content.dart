import 'package:flutter/material.dart';
import '../models/user.dart';
import '../screens/profile/profile_screen.dart';

class HomeHeaderContent extends StatelessWidget {
  final User? currentUser;
  final VoidCallback onLogout;

  const HomeHeaderContent({
    super.key,
    required this.currentUser,
    required this.onLogout,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentUser?.name ?? 'User',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        _buildProfileMenu(context),
      ],
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    return PopupMenuButton<String>(
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          child: Text(
            currentUser?.name.substring(0, 1).toUpperCase() ?? 'U',
            style: const TextStyle(
              color: Color(0xFF6366F1),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
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
