import '../../bloc/blocs.dart';
import '../../bloc/utils/resolver.dart';

class LoadTopicsResolver extends Resolver {
  static CubitFactory Function()
  get factory => () {
    return () => TopicCubit()..loadTopics();
  };

  LoadTopicsResolver({ 
    super.key, 
    required super.builder,
  }) : super(
    cubitFactory: factory(),
  );
}
