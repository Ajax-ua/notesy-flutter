    
import '../../bloc/blocs.dart';
import '../../bloc/utils/resolver.dart';

class LoadTopicsResolver extends Resolver {
  LoadTopicsResolver({ 
    super.key, 
    required super.builder,
  }) : super(
    cubitFactory: () => TopicCubit()..loadTopics(),
  );
}