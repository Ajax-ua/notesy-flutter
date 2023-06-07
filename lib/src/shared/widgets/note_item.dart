import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:notesy_flutter/src/theme/app_typography.dart';

import '../../bloc/blocs.dart';
import '../../repos/repos.dart';
import '../../theme/app_colors.dart';
import '../models/models.dart';

enum NoteAction {
  edit,
  remove,
}

class NoteItem extends StatelessWidget {
  final Note note;
  final bool collapsed;
  final _noteCubit = NoteCubit();
  final _authCubit = AuthCubit();
  final _topicCubit = TopicCubit();
  final AppRepository _appRepository = AppRepository();

  NoteItem({
    super.key,
    required this.note,
    this.collapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOwner = note.userId == _authCubit.state.user?.uid;
    final String? topicLabel = _topicCubit.state.entities[note.topicId]?.label;
    final DateTime createdAt = DateTime.fromMillisecondsSinceEpoch(note.createdAt ?? 0);
    final String formattedCreatedAt = note.createdAt != null ? DateFormat('dd/MM/yyyy, HH:mm').format(createdAt) : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: GestureDetector(
                child:  Text(
                  note.title,
                  overflow: collapsed ? TextOverflow.ellipsis : TextOverflow.visible,
                  maxLines: collapsed ? 2 : null,
                  style: AppTypography.h3,
                ),
                onTap:() {
                  if (collapsed) {
                    context.go('/notes/${note.id}', extra: GoRouter.of(context).location);
                  }
                },
              ),
            ),
            if (isOwner)
              PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<NoteAction>(
                      value: NoteAction.edit,
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<NoteAction>(
                      value: NoteAction.remove,
                      child: Text('Delete'),
                    ),
                  ];
                },
                onSelected: (NoteAction action) {
                  switch(action) {
                    case NoteAction.edit:
                      context.go('/notes/${note.id}/edit');
                      break;
                    case NoteAction.remove:
                      _appRepository.showConfirmDialog(
                        message: 'The note will be removed completely', onSubmit: () {
                          _noteCubit.deleteNote(note);
                        },
                      );
                      break;
                  }
                },
                child: Row(children: const [
                  SizedBox(width: 10),
                  Icon(Icons.more_vert_rounded),
                ]),
              ),
          ],
        ),
        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (topicLabel != null) 
              Text(topicLabel, style: const TextStyle(color: AppColors.grey)),
            const SizedBox(width: 10),
            Text(formattedCreatedAt, style: const TextStyle(color: AppColors.grey)),
          ],
        ),
        const SizedBox(height: 10),

        GestureDetector(
          child:  Text(
            note.text,
            overflow: collapsed ? TextOverflow.ellipsis : TextOverflow.visible,
            maxLines: collapsed ? 10 : null,
          ),
          onTap:() {
            if (collapsed) {
              context.go('/notes/${note.id}', extra: GoRouter.of(context).location);
            }
          },
        ),
      ],
    );
  }
}