import 'package:flutter/material.dart';

import '../../bloc/blocs.dart';
import '../../repos/repos.dart';
import '../../shared/widgets/note_form.dart';

class AddNote extends StatelessWidget {
  final _noteCubit = NoteCubit();
  final _appRepository = AppRepository();
  final _routerRepository = RouterRepository();

  AddNote({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        NoteForm(onSubmit: (note) async {
          final addedNote = await _noteCubit.addNote(note);
          if (addedNote != null) {
            _appRepository.showToastr(message: 'Saved successfully', type: ToastrType.success);
            _routerRepository.navigate('/');
          }
        }),
      ],
    );
  }
}