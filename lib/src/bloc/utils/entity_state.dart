import 'request_status.dart';

class Request {
  RequestStatus requestStatus;
  String? error;

  Request({this.requestStatus = RequestStatus.initial, this.error});
}

class EntityState<Entity, IdType> extends Request{
  final Map<String, Request> requests = {};
  final Map<IdType, Entity> entities;
  final IdType? selectedId;

  EntityState({ 
    required super.requestStatus, 
    super.error,
    this.entities = const {},
    this.selectedId,
  });

  List<Entity> get entityList {
    return entities.values.toList();
  }

  Entity? get selectedEntity {
    return entities[selectedId];
  }

  Request createRequest({required String name}) {
    requests[name] = Request();
    return requests[name]!;
  }
}