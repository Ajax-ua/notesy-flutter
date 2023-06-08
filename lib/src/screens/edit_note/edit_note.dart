import 'package:flutter/material.dart';

import '../../bloc/blocs.dart';
import '../../repos/repos.dart';
import '../../shared/models/models.dart';
import '../../shared/widgets/note_form.dart';

class EditNote extends StatelessWidget {
  final _noteCubit = NoteCubit();

  EditNote({super.key});

  @override
  Widget build(BuildContext context) {
    final Note note = _noteCubit.state.selectedEntity!;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        NoteForm(
          note: note,
          onSubmit: (note) async {
            final updatedNote = await _noteCubit.updateNote(note);
            if (updatedNote != null) {
              AppRepository().showToastr(message: 'Saved successfully', type: ToastrType.success);
              RouterRepository().goBack(context);
            }
          }
        ),
      ],
    );
  }
}