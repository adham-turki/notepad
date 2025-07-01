import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/note.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/database_helper.dart';
import '../auth/login_screen.dart';
import '../note/note_editor_screen.dart';
import '../../widgets/home_header.dart';
import '../../widgets/notes_grid.dart';
import '../../widgets/pagination_controls.dart';
import '../../widgets/home_screen_content.dart';
import '../../widgets/home_screen_fab.dart';

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
    
    if (_currentPage > _totalPages) {
      _currentPage = _totalPages;
    }
    
    final startIndex = (_currentPage - 1) * _notesPerPage;
    final endIndex = (startIndex + _notesPerPage).clamp(0, _allNotes.length);
    
    _currentPageNotes = _allNotes.sublist(startIndex, endIndex);
  }

  Future<void> _changePage(int newPage) async {
    if (newPage == _currentPage || newPage < 1 || newPage > _totalPages) return;
    
    await _pageTransitionController.reverse();
    setState(() {
      _currentPage = newPage;
      _updatePagination();
    });
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

  Future<void> _toggleNotePin(Note note) async {
    HapticFeedback.lightImpact();
    await DatabaseHelper.instance.toggleNotePin(note.id!, !note.isPinned);
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const HomeScreenContent(isLoading: true);
    }

    return Scaffold(
      body: HomeScreenContent(
        isLoading: false,
        currentUser: _currentUser,
        allNotes: _allNotes,
        currentPageNotes: _currentPageNotes,
        currentPage: _currentPage,
        totalPages: _totalPages,
        fadeAnimation: _fadeAnimation,
        slideAnimation: _slideAnimation,
        pageTransitionAnimation: _pageTransitionAnimation,
        onLogout: _logout,
        onNoteTap: (note) => _navigateToEditor(note: note),
        onDeleteNote: _deleteNote,
        onTogglePin: _toggleNotePin,
        onPageChanged: _changePage,
      ),
      floatingActionButton: HomeScreenFAB(
        onPressed: () => _navigateToEditor(),
      ),
    );
  }
}