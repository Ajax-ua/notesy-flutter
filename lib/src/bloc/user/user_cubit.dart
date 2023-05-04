import '../../shared/models/models.dart';
import '../../repos/repos.dart';
import '../utils/entity_cubit.dart';
import '../utils/request_status.dart';
import 'user_state.dart';

class UserCubit extends EntityCubit<UserState> {
  UserCubit._() : super(UserState());
  static final UserCubit _instance = UserCubit._();
  factory UserCubit() {
    return _instance;
  }

  final _userRepository = UserRepository();

  emitError(error) {
    emit(state.copyWith(
      requestStatus: RequestStatus.failed,
      error: error.toString().replaceFirst('Exception: ', ''),
    ));
  }

  Future<void> loadUsers({bool? reload}) async {
    reload ??= false;
    try {
      emit(state.copyWith(requestStatus: RequestStatus.inProgress));
      final List<User> items = await _userRepository.loadUsers();
      itemsLoadSuccess(items);
    } catch(error) {
      emitError(error);
    }
  }

  void itemsLoadSuccess(List<User> loadedItems) {
    final Map<String, User> loadedItemsMap = { 
      for (var v in loadedItems) v.id! : v,
    };
    
    final items = { ...state.entities, ...loadedItemsMap};
    emit(state.copyWith(entities: items, requestStatus: RequestStatus.succeed));
  }

  selectUser(String? id) {
    emit(state.copyWith(selectedId: id));
  }

  void setFilterKey(String key) {
    emit(state.copyWith(filterKey: key));
  }

  Future<void> loadUser(String itemId) async {
    // do not load it already loaded
    if (state.entities[itemId] != null) {
      emit(state.copyWith(selectedId: itemId));
      return;
    }

    try {
      emit(state.copyWith(requestStatus: RequestStatus.inProgress));
      final User loadedItem = await _userRepository.loadUser(itemId);
      final users = { ...state.entities };
      users[loadedItem.id!] = loadedItem;
      emit(state.copyWith(entities: users, selectedId: loadedItem.id, requestStatus: RequestStatus.succeed));
    } catch(error) {
      emitError(error);
    }
  }
  
}