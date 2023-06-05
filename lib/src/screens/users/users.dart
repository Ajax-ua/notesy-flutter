import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/blocs.dart';
import '../../shared/models/models.dart';
import '../../theme/app_colors.dart';

int currentCursorPosition = 0;

class Users extends StatelessWidget {
  Users({super.key});

  final _userCubit = UserCubit();

  @override
  Widget build(BuildContext context) {
    final List<User> users = _userCubit.state.filteredUsers;
    Timer? debounce;
    final filterCtrl = TextEditingController(text: _userCubit.state.filterKey);
    filterCtrl.selection = TextSelection.collapsed(offset: currentCursorPosition);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      children: [
        TextFormField(
          controller: filterCtrl,
          decoration: InputDecoration(
            label: const Text('Search'),
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              onPressed: () {
                filterCtrl.clear();
                currentCursorPosition = 0;
                _userCubit.setFilterKey('');
              },
              icon: const Icon(Icons.clear),
            ),
          ),
          onChanged: (value) {
            currentCursorPosition = filterCtrl.selection.base.offset;
            if (debounce?.isActive ?? false) debounce?.cancel();
            debounce = Timer(const Duration(milliseconds: 500), () {
              _userCubit.setFilterKey(value);
            });
          },
        ),
        const SizedBox(height: 25),

        users.isEmpty
          ? const Text('No match found', style: TextStyle(color: AppColors.grey))
          : ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final User user = users[index];
              return Column(
                children: [
                  ListTile(
                    onTap: () => context.go('/user/${user.id}'),
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade100,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/300?${DateTime.now().millisecondsSinceEpoch}'),
                    ),
                    title: Text(user.email),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }
          ),
      ],
    );
  }
}