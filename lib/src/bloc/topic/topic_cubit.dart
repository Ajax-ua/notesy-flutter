import '../../shared/models/models.dart';
import '../../repos/repos.dart';
import '../utils/entity_cubit.dart';
import '../utils/request_status.dart';
import 'topic_state.dart';

class TopicCubit extends EntityCubit<TopicState> {
  TopicCubit._() : super(TopicState());
  static final TopicCubit _instance = TopicCubit._();
  factory TopicCubit() {
    return _instance;
  }

  final _topicRepository = TopicRepository();

  emitError(error) {
    emit(state.copyWith(
      requestStatus: RequestStatus.failed,
      error: error.toString().replaceFirst('Exception: ', ''),
    ));
  }

  Future<void> loadTopics({bool reload = false}) async {
    try {
      emit(state.copyWith(requestStatus: RequestStatus.inProgress));
      final List<Topic> items = await _topicRepository.loadTopics();
      itemsLoadSuccess(items);
    } catch(error) {
      emitError(error);
    }
  }

  void itemsLoadSuccess(List<Topic> loadedItems) {
    final Map<String, Topic> loadedItemsMap = { 
      for (var v in loadedItems) v.id! : v,
    };
    
    final items = { ...state.entities, ...loadedItemsMap};
    emit(state.copyWith(entities: items, requestStatus: RequestStatus.succeed));
  }

  selectTopic(String? topicId) {
    emit(state.copyWith(selectedId: topicId));
  }
  
}