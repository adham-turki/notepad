import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/user.dart';
import 'home_header.dart';
import 'notes_grid.dart';
import 'pagination_controls.dart';
import 'home_empty_state.dart';

class HomeScreenContent extends StatelessWidget {
  final bool isLoading;
  final User? currentUser;
  final List<Note>? allNotes;
  final List<Note>? currentPageNotes;
  final int? currentPage;
  final int? totalPages;
  final Animation<double>? fadeAnimation;
  final Animation<Offset>? slideAnimation;
  final Animation<double>? pageTransitionAnimation;
  final VoidCallback? onLogout;
  final Function(Note)? onNoteTap;
  final Function(Note)? onDeleteNote;
  final Function(Note)? onTogglePin;
  final Function(int)? onPageChanged;

  const HomeScreenContent({
    super.key,
    required this.isLoading,
    this.currentUser,
    this.allNotes,
    this.currentPageNotes,
    this.currentPage,
    this.totalPages,
    this.fadeAnimation,
    this.slideAnimation,
    this.pageTransitionAnimation,
    this.onLogout,
    this.onNoteTap,
    this.onDeleteNote,
    this.onTogglePin,
    this.onPageChanged,
  });

  int _getTodayNotesCount() {
    if (allNotes == null) return 0;
    final today = DateTime.now();
    return allNotes!.where((note) {
      return note.createdAt.year == today.year &&
             note.createdAt.month == today.month &&
             note.createdAt.day == today.day;
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6366F1),
                Color(0xFF8B5CF6),
                Color(0xFFA855F7),
              ],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF8FAFC),
                  Color(0xFFE2E8F0),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  HomeHeader(
                    currentUser: currentUser,
                    notesCount: allNotes?.length ?? 0,
                    todayNotesCount: _getTodayNotesCount(),
                    onLogout: onLogout!,
                    fadeAnimation: fadeAnimation!,
                    slideAnimation: slideAnimation!,
                  ),
                  Expanded(
                    child: (allNotes?.isEmpty ?? true)
                        ? HomeEmptyState(fadeAnimation: fadeAnimation!)
                        : SingleChildScrollView(
                            child: FadeTransition(
                              opacity: pageTransitionAnimation!,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.1, 0),
                                  end: Offset.zero,
                                ).animate(pageTransitionAnimation!),
                                child: NotesGrid(
                                  notes: currentPageNotes!,
                                  onNoteTap: onNoteTap!,
                                  onNoteDelete: onDeleteNote!,
                                  onTogglePin: onTogglePin!,
                                  fadeAnimation: pageTransitionAnimation!,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          // Pagination controls
          if ((totalPages ?? 0) > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: PaginationControls(
                  currentPage: currentPage!,
                  totalPages: totalPages!,
                  onPageChanged: onPageChanged!,
                  fadeAnimation: fadeAnimation!,
                ),
              ),
            ),
        ],
      ),
    );
  }
}