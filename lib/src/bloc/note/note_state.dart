import '../../shared/models/models.dart';
import '../utils/request_status.dart';
import '../utils/entity_state.dart';

class NoteState extends EntityState<Note, String> {
  final String filterKey;
  final List<String> ids;

  NoteState({
    super.requestStatus = RequestStatus.initial,
    super.error,
    super.entities,
    super.selectedId,
    this.filterKey = '',
    this.ids = const [],
  }); 

  @override
  String toString() {
    return 'Note{notes: $entities, selectedId: $selectedId, status: $requestStatus, error: $error, filterKey: $filterKey, ids: $ids}';
  }

  NoteState copyWith({
    Map<String, Note>? entities,
    String? selectedId,
    RequestStatus? requestStatus,
    String? error,
    String? filterKey,
    List<String>? ids,
  }) {
    return NoteState(
      entities: entities ?? this.entities,
      selectedId: selectedId ?? this.selectedId,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
      filterKey: filterKey ?? this.filterKey,
      ids: ids ?? this.ids,
    );
  }

  List<Note> get currentNotes {
    return ids.map((id) {
      return entities[id]!;
    }).toList();
  }
}