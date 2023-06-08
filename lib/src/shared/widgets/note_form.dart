import 'package:flutter/material.dart';

import '../../bloc/blocs.dart';
import '../models/models.dart';

class NoteForm extends StatefulWidget {
  final Note? note;
  final Future<void> Function(Note note) onSubmit;

  const NoteForm({super.key, this.note, required this.onSubmit});

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _form = GlobalKey<FormState>();
  late Map<String, TextEditingController> controllers;
  late Note note;
  String? selectedTopicId;
  late List<DropdownMenuItem<String>> topicItems;
  final _topicCubit = TopicCubit();

  @override
  void initState() {
    super.initState();
    selectedTopicId = widget.note?.topicId;
    note = widget.note ?? Note(title: '', text: '', topicId: '');
    controllers = {
      'title': TextEditingController(text: note.title),
      'text': TextEditingController(text: note.text),
    };

    topicItems = _topicCubit.state.entityList
      .map((topic) {
        return DropdownMenuItem<String>(
          value: topic.id,
          child: Text(topic.label),
        );
      })
      .toList();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    for (final ctrl in controllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form (
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Title',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            controller: controllers['title'],
            onSaved: (String? value) {
              // This optional block of code can be used to run
              // code when the user saves the form.
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Title is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          
          DropdownButtonFormField(
            icon: const Icon(Icons.arrow_drop_down),
            value: selectedTopicId,
            items: topicItems,
            decoration: const InputDecoration(
              labelText: 'Topic',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            onChanged: (topicId) {
              selectedTopicId = topicId;
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please select Topic';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),

          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Text',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            controller: controllers['text'],
            maxLength: 10000,
            maxLines: 4,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Text is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: _submit,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_form.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      note.title = controllers['title']?.text ?? note.title;
      note.text = controllers['text']?.text ?? note.text;
      note.topicId = selectedTopicId ?? note.topicId;

      await widget.onSubmit(note);
    }
  }

}