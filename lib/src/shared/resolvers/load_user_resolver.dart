import '../../bloc/blocs.dart';
import '../../bloc/utils/resolver.dart';
    
class LoadUserResolver extends Resolver {
  static CubitFactory Function(String)
  get factory => (String itemId) {
    return () => UserCubit()..loadUser(itemId);
  };

  LoadUserResolver({ 
    super.key, 
    required String itemId, 
    required super.builder,
  }) : super(
    cubitFactory: factory(itemId),
  );
}