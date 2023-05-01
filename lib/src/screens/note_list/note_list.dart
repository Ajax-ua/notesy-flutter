import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/blocs.dart';
import '../../shared/models/models.dart';
import '../../shared/widgets/note_item.dart';

class NoteList extends StatelessWidget {
  final _noteCubit = NoteCubit();
  final _topicCubit = TopicCubit();

  NoteList({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = _topicCubit.state.entityList..insert(0, Topic(id: '', label: 'All'));
    final notes = _noteCubit.state.currentNotes;
    // Timer? debounce;
    // final searchCtrl = TextEditingController(text: _noteCubit.state.filterKey);

    return RefreshIndicator(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          // TODO: apply search box when api is updated to support search
          // TextFormField(
          //   controller: searchCtrl,
          //   decoration: InputDecoration(
          //     label: const Text('Search'),
          //     prefixIcon: const Icon(Icons.search),
          //     border: const OutlineInputBorder(),
          //     suffixIcon: IconButton(
          //       onPressed: () {
          //         searchCtrl.clear();
          //         _noteCubit.setFilterKey('');
          //       },
          //       icon: const Icon(Icons.clear),
          //     ),
          //   ),
          //   onChanged: (value) {
          //     if (debounce?.isActive ?? false) debounce?.cancel();
          //     debounce = Timer(const Duration(milliseconds: 500), () {
          //       _noteCubit.setFilterKey(value);
          //     });
          //   },
          // ),
          // const SizedBox(height: 15),

          BlocBuilder<TopicCubit, TopicState>(
            bloc: _topicCubit,
            builder: (context, state) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: topics.map((topic) {
                    final selectedTopicId = _topicCubit.state.selectedId ?? '';
                    final bool isSelected = selectedTopicId == topic.id;
                    return Row(
                      children: [
                        ChoiceChip(
                          label: Text(topic.label),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          selected: isSelected,
                          labelStyle: TextStyle (
                            color: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
                          ),
                          selectedColor: Theme.of(context).colorScheme.primary,
                          onSelected: (bool value) {
                            if (!value && topic.id == '') {
                              return;
                            }
                            final String? topicId = value ? topic.id : '';
                            _topicCubit.selectTopic(topicId);
                            _noteCubit.loadNotes(reload: true);
                          },
                        ),
                        const SizedBox(width: 5),
                      ],
                    );
                  }).toList(),
                ),
              );

              // dropdown version of filtering the notes by topic
              // final List<DropdownMenuItem<String>> topicItems = topics
              //   .map((topic) {
              //     return DropdownMenuItem<String>(
              //       value: topic.id,
              //       child: Text(topic.label),
              //     );
              //   })
              //   .toList()
              //   ..insert(0, const DropdownMenuItem<String>(
              //     value: '',
              //     child: Text('All topics'),
              //   ));
              // return SizedBox(
              //   height: 50,
              //   child: DropdownButtonFormField(
              //     isExpanded: true,
              //     icon: const Icon(Icons.arrow_drop_down),
              //     value: _topicCubit.state.selectedId ?? '',
              //     items: topicItems,
              //     decoration: const InputDecoration(
              //       border: OutlineInputBorder(),
              //     ),
              //     onChanged: (topicId) {
              //       _topicCubit.selectTopic(topicId!);
              //       _noteCubit.loadNotes(reload: true);
              //     },
              //   ),
              // );
            },
          ),
          const SizedBox(height: 15),

          notes.isEmpty
            ? const Text('No notes found', style: TextStyle(color: Colors.grey))
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
            ),

        ],
      ),
      onRefresh: () async {
        await _noteCubit.loadNotes(reload: true);
      },
    );
  }
}