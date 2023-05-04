import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'entity_state.dart';
import 'request_status.dart';
import 'entity_cubit.dart';

typedef BuilderParams = Map<String, Object>?;
typedef CubitFactory = EntityCubit Function();

class Resolver extends StatefulWidget {
  final Widget Function(BuilderParams data) builder;
  final BuilderParams data;
  final CubitFactory cubitFactory;

  const Resolver({ 
    super.key, 
    required this.cubitFactory, 
    required this.builder, 
    this.data,
  });
  
  @override
  ResolverState createState() => ResolverState();
}

class ResolverState extends State<Resolver>{
  late final EntityCubit cubit;

  @override
  void initState() {
    cubit = widget.cubitFactory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: cubit,
      builder: (context, EntityState state) {
        if (state.requestStatus == RequestStatus.failed) {
          return Text(state.error!);
        }

        if (state.requestStatus == RequestStatus.succeed) {
          return widget.builder(widget.data);
        }

        // By default, show a loading spinner.
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}