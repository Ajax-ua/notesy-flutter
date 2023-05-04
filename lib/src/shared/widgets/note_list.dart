import 'package:flutter/material.dart';

import '../../shared/models/models.dart';
import '../../shared/widgets/note_item.dart';
import '../../theme/app_colors.dart';

class NoteList extends StatelessWidget {
  final List<Note> notes;

  const NoteList({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return notes.isEmpty
      ? const Text('No notes found', style: TextStyle(color: AppColors.grey))
      : ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: notes.length,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemBuilder: (BuildContext context, int index) {
          final note = notes[index];
          return NoteItem(note: note, collapsed: true);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Column(
            children: const [
              SizedBox(height: 15),
              Divider(),
              SizedBox(height: 15),
            ],
          );
        },
      );
  }
}