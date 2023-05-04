import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/blocs.dart';
import '../../shared/models/models.dart';
import '../../shared/widgets/note_item.dart';

class NoteDetails extends StatelessWidget {
  final _noteCubit = NoteCubit();

  NoteDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final Note note = _noteCubit.state.selectedEntity!;
    final sourceUrl = (GoRouterState.of(context).extra ?? '/') as String;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.canPop() ? context.pop() : context.go(sourceUrl),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: NoteItem(note: note),
      ),
    );
  }
}