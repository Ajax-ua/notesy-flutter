import '../../shared/models/models.dart';
import '../utils/request_status.dart';
import '../utils/entity_state.dart';

class UserState extends EntityState<User, String> {
  final String filterKey;

  UserState({
    super.requestStatus = RequestStatus.initial,
    super.error,
    super.entities,
    super.selectedId,
    this.filterKey = '',
  }); 

  @override
  String toString() {
    return 'User{entities: $entities, selectedId: $selectedId, status: $requestStatus, error: $error, filterKey: $filterKey}';
  }

  UserState copyWith({
    Map<String, User>? entities,
    String? selectedId,
    RequestStatus? requestStatus,
    String? error,
    String? filterKey,
  }) {
    return UserState(
      entities: entities ?? this.entities,
      selectedId: selectedId ?? this.selectedId,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
      filterKey: filterKey ?? this.filterKey,
    );
  }

  List<User> get filteredUsers {
    return entityList.where((item) {
      final key = filterKey.toLowerCase();
      return item.email.contains(key) || item.name.toLowerCase().contains(key);
    }).toList();
  }

}