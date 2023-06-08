import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../bloc/blocs.dart';
import '../../repos/repos.dart';
import '../../shared/models/models.dart';
import '../../shared/widgets/note_list.dart';

class UserProfile extends StatelessWidget {
  UserProfile({super.key});

  final _userCubit = UserCubit();
  final _noteCubit = NoteCubit();
  final _routerRepository= RouterRepository();

  @override
  Widget build(BuildContext context) {
    final User user = _userCubit.state.selectedEntity!;
    final List<Note> notes = _noteCubit.state.currentNotes;
    final String avatarUrl = 'https://i.pravatar.cc/300?${DateTime.now().millisecondsSinceEpoch}';

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent
    ));

    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  height: 126,
                  color: Theme.of(context).colorScheme.background,
                ),
                Positioned(
                  top: 50,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                    onPressed: () => _routerRepository.goBack(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 55),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 57,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 54,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(avatarUrl),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Text(user.email, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
        
            Expanded(
              child: RefreshIndicator(
                child: 
                  ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  children: [
                    NoteList(notes: notes),
                  ],
                  ),
                onRefresh: () async {
                  await _noteCubit.loadNotes(reset: true, userId: _userCubit.state.selectedId);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}