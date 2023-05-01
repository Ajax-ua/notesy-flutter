import '../../bloc/utils/resolver.dart';
import '../../bloc/blocs.dart';
    
class LoadNotesResolver extends Resolver {
  LoadNotesResolver({ 
    super.key, 
    required super.builder,
  }) : super(
    cubitFactory: () => NoteCubit()..loadNotes(),
  );
}