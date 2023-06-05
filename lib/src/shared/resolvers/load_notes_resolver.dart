import '../../bloc/utils/resolver.dart';
import '../../bloc/blocs.dart';

class LoadNotesResolver extends Resolver {
  static CubitFactory Function({bool? reset, String? userId})
  get factory => ({bool? reset, String? userId}) {
    return () => NoteCubit()..loadNotes(reset: reset, userId: userId);
  };

  LoadNotesResolver({
    super.key,
    userId,
    required super.builder,
  }) : super(
    cubitFactory: factory(reset: true, userId: userId),
    showSpinner: false,
  );
}