import 'package:flutter/material.dart';

class HomeHeaderStats extends StatelessWidget {
  final int notesCount;
  final int todayNotesCount;

  const HomeHeaderStats({
    super.key,
    required this.notesCount,
    required this.todayNotesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _buildStatItem(
            icon: Icons.note_alt_outlined,
            label: 'Total Notes',
            value: '$notesCount',
          ),
          const SizedBox(width: 30),
          _buildStatItem(
            icon: Icons.today_outlined,
            label: 'Today',
            value: todayNotesCount.toString(),
          ),
          const Spacer(),
          _buildActiveIndicator(),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.9),
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981), // Green color
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.trending_up,
            size: 16,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            'Active',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
