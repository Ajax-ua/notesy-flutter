import '../../shared/models/models.dart';
import '../utils/request_status.dart';
import '../utils/entity_state.dart';

class TopicState extends EntityState<Topic, String> {
  TopicState({
    super.requestStatus = RequestStatus.initial,
    super.error,
    super.entities,
    super.selectedId,
  }); 

  @override
  String toString() {
    return 'Topic{entities: $entities, selectedId: $selectedId, status: $requestStatus, error: $error}';
  }

  TopicState copyWith({
    Map<String, Topic>? entities,
    String? selectedId,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return TopicState(
      entities: entities ?? this.entities,
      selectedId: selectedId ?? this.selectedId,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

}