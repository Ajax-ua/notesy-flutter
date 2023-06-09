import '../../bloc/blocs.dart';
import '../../bloc/utils/resolver.dart';
    
class LoadNoteResolver extends Resolver {
  static CubitFactory Function(String)
  get factory => (String itemId) {
    return () => NoteCubit()..loadNote(itemId);
  };

  LoadNoteResolver({ 
    super.key, 
    required String itemId, 
    required super.builder,
  }) : super(
    cubitFactory: factory(itemId),
  );
}