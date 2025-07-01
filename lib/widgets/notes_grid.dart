import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/note.dart';
import 'note_card.dart';

class NotesGrid extends StatelessWidget {
  final List<Note> notes;
  final Function(Note) onNoteTap;
  final Function(Note) onNoteDelete;
  final Animation<double> fadeAnimation;

  const NotesGrid({
    super.key,
    required this.notes,
    required this.onNoteTap,
    required this.onNoteDelete,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: MasonryGridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return NoteCard(
              note: notes[index],
              onTap: () => onNoteTap(notes[index]),
              onDelete: () => onNoteDelete(notes[index]),
            );
          },
        ),
      ),
    );
  }
}
