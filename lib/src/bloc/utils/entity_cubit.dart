import 'package:flutter_bloc/flutter_bloc.dart';

import 'entity_state.dart';


class EntityCubit<T extends EntityState> extends Cubit<T> {
  EntityCubit(T state) : super(state);
}