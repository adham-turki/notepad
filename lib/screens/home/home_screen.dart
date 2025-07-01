import 'package:flutter/material.dart';
import '../../models/note.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/database_helper.dart';
import '../auth/login_screen.dart';
import '../note/note_editor_screen.dart';
import '../../widgets/home_header.dart';
import '../../widgets/notes_grid.dart';
import '../../widgets/pagination_controls.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  User? _currentUser;
  List<Note> _allNotes = [];
  List<Note> _currentPageNotes = [];
  bool _isLoading = true;
  
  // Pagination
  int _currentPage = 1;
  final int _notesPerPage = 9;
  int _totalPages = 1;
  
  late AnimationController _animationController;
  late AnimationController _pageTransitionController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pageTransitionAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserAndNotes();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pageTransitionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    
    _pageTransitionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pageTransitionController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageTransitionController.dispose();
    super.dispose();
  }

  Future<void> _loadUserAndNotes() async {
    setState(() => _isLoading = true);
    
    _currentUser = await AuthService.getCurrentUser();
    if (_currentUser != null) {
      _allNotes = await DatabaseHelper.instance.getNotesByUserId(_currentUser!.id!);
      _updatePagination();
    }
    
    setState(() => _isLoading = false);
    _animationController.forward();
    _pageTransitionController.forward();
  }

  void _updatePagination() {
    _totalPages = (_allNotes.length / _notesPerPage).ceil();
    if (_totalPages == 0) _totalPages = 1;
    
    // Ensure current page is valid
    if (_currentPage > _totalPages) {
      _currentPage = _totalPages;
    }
    
    final startIndex = (_currentPage - 1) * _notesPerPage;
    final endIndex = (startIndex + _notesPerPage).clamp(0, _allNotes.length);
    
    _currentPageNotes = _allNotes.sublist(startIndex, endIndex);
  }

  Future<void> _changePage(int newPage) async {
    if (newPage == _currentPage || newPage < 1 || newPage > _totalPages) return;
    
    // Animate out
    await _pageTransitionController.reverse();
    
    setState(() {
      _currentPage = newPage;
      _updatePagination();
    });
    
    // Animate in
    await _pageTransitionController.forward();
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  Future<void> _deleteNote(Note note) async {
    await DatabaseHelper.instance.deleteNote(note.id!);
    await _loadUserAndNotes();
  }

  Future<void> _navigateToEditor({Note? note}) async {
    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => NoteEditorScreen(
          userId: _currentUser!.id!,
          note: note,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
    if (result == true) {
      await _loadUserAndNotes();
    }
  }

  int _getTodayNotesCount() {
    final today = DateTime.now();
    return _allNotes.where((note) {
      return note.createdAt.year == today.year &&
             note.createdAt.month == today.month &&
             note.createdAt.day == today.day;
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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
                    currentUser: _currentUser,
                    notesCount: _allNotes.length,
                    todayNotesCount: _getTodayNotesCount(),
                    onLogout: _logout,
                    fadeAnimation: _fadeAnimation,
                    slideAnimation: _slideAnimation,
                  ),
                  Expanded(
                    child: _allNotes.isEmpty 
                        ? _buildEmptyState() 
                        : SingleChildScrollView(
                            child: FadeTransition(
                              opacity: _pageTransitionAnimation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.1, 0),
                                  end: Offset.zero,
                                ).animate(_pageTransitionAnimation),
                                child: NotesGrid(
                                  notes: _currentPageNotes,
                                  onNoteTap: (note) => _navigateToEditor(note: note),
                                  onNoteDelete: _deleteNote,
                                  fadeAnimation: _pageTransitionAnimation,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          // Centered floating pagination controls at FAB level
          if (_totalPages > 1)
            Positioned(
              bottom: 16, // Same level as FAB
              left: 0,
              right: 0,
              child: Center(
                child: PaginationControls(
                  currentPage: _currentPage,
                  totalPages: _totalPages,
                  onPageChanged: _changePage,
                  fadeAnimation: _fadeAnimation,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToEditor(),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 8,
        icon: const Icon(Icons.add),
        label: const Text('New Note'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade100,
                    Colors.grey.shade200,
                  ],
                ),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.note_add_outlined,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No notes yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to create your first note',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
