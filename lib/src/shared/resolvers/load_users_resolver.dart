import '../../bloc/blocs.dart';
import '../../bloc/utils/resolver.dart';
    
class LoadUsersResolver extends Resolver {
  static CubitFactory Function({bool? reload})
  get factory => ({bool? reload}) {
    return () => UserCubit()..loadUsers(reload: reload);
  };

  LoadUsersResolver({ 
    super.key, 
    required super.builder,
  }) : super(
    cubitFactory: factory(),
  );
}