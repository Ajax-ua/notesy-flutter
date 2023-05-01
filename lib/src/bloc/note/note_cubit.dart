import '../../shared/models/models.dart';
import '../../repos/repos.dart';
import '../topic/topic.dart';
import '../utils/entity_cubit.dart';
import '../utils/request_status.dart';
import 'note_state.dart';

class NoteCubit extends EntityCubit<NoteState> {
  NoteCubit._() : super(NoteState());
  static final NoteCubit _instance = NoteCubit._();
  factory NoteCubit() {
    return _instance;
  }

  final _noteRepository = NoteRepository();
  final _topicCubit = TopicCubit();

  emitError(error) {
    emit(state.copyWith(
      requestStatus: RequestStatus.failed,
      error: error.toString().replaceFirst('Exception: ', ''),
    ));
  }

  Future<void> addNote(Note note) async {
    try {
      emit(state.copyWith(requestStatus: RequestStatus.inProgress));
      final Note addedItem = await _noteRepository.addNote(note);
      final notes = state.entities;
      notes[addedItem.id!] = addedItem;
      emit(state.copyWith(entities: notes, requestStatus: RequestStatus.succeed));
    } catch(error) {
      emitError(error);
      rethrow;
    }
  }

  Future<void> loadNotes({bool reload = false}) async {
    try {
      emit(state.copyWith(requestStatus: RequestStatus.inProgress));
      String selectedTopicId = _topicCubit.state.selectedId ?? '';
      String searchKey = state.filterKey;
      final List<Note> tasks = await _noteRepository.loadNotes(
        topicId: selectedTopicId.isNotEmpty ? selectedTopicId : null,
        searchKey: searchKey.isNotEmpty ? searchKey : null,
      );
      if (reload) {
        emit(state.copyWith(ids: []));
      }
      notesLoadSuccess(tasks);
    } catch(error) {
      emitError(error);
    }
  }

  void notesLoadSuccess(List<Note> loadedItems) {
    final Map<String, Note> loadedItemsMap = { 
      for (var v in loadedItems) v.id! : v,
    };
    
    final items = { ...state.entities, ...loadedItemsMap};
    final List<String> ids = [
      ...state.ids, 
      ...loadedItems.map((item) => item.id!),
    ];

    emit(state.copyWith(
      entities: items,
      requestStatus: RequestStatus.succeed,
      ids: ids,
    ));
  }

  Future<void> updateNote(Note task) async {
    try {
      emit(state.copyWith(requestStatus: RequestStatus.inProgress));
      final Note updatedItem = await _noteRepository.updateNote(task);
      final notes = state.entities;
      notes[updatedItem.id!] = updatedItem;
      emit(state.copyWith(entities: notes, requestStatus: RequestStatus.succeed));
    } catch(error) {
      emitError(error);
    }
  }

  Future<void> deleteNote(Note note) async {
    try {
      emit(state.copyWith(requestStatus: RequestStatus.inProgress));
      final Note deletedTask = await _noteRepository.deleteNote(note);
      final notes = state.entities..remove(deletedTask.id);
      emit(state.copyWith(entities: notes, requestStatus: RequestStatus.succeed));
    } catch(error) {
      emitError(error);
    }
  }

  Future<void> loadNote(String itemId) async {
    try {
      emit(state.copyWith(requestStatus: RequestStatus.inProgress));
      final Note loadedItem = await _noteRepository.loadNote(itemId);
      final notes = { ...state.entities };
      notes[loadedItem.id!] = loadedItem;
      emit(state.copyWith(entities: notes, selectedId: loadedItem.id, requestStatus: RequestStatus.succeed));
    } catch(error) {
      emitError(error);
    }
  }

  void setFilterKey(String key) {
    emit(state.copyWith(filterKey: key));
  }
}