import '../../bloc/blocs.dart';
import '../../bloc/utils/resolver.dart';
    
class LoadNoteResolver extends Resolver {
  LoadNoteResolver({ 
    super.key, 
    required String itemId, 
    required super.builder,
  }) : super(
    cubitFactory: () => NoteCubit()..loadNote(itemId),
  );
}