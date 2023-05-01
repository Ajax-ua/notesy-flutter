import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'entity_state.dart';
import 'request_status.dart';
import 'entity_cubit.dart';

class MultiBlocResolver extends StatefulWidget {
  final Widget Function(Map<String, Object>? data) builder;
  final Map<String, Object>? data;
  final Iterable<EntityCubit Function()> cubitFactories;

  const MultiBlocResolver({ 
    super.key, 
    required this.cubitFactories, 
    required this.builder, 
    this.data,
  });
  
  @override
  MultiBlocResolverState createState() => MultiBlocResolverState();
}

class MultiBlocResolverState extends State<MultiBlocResolver>{
  late final Stream<Iterable<EntityState>>combinedStream$;

  @override
  void initState() {
    final Iterable<Stream<EntityState>> streams = widget.cubitFactories.map((cf) => cf().stream);
    combinedStream$ = CombineLatestStream.list(streams);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: combinedStream$,
      builder: (context, AsyncSnapshot<Iterable<EntityState>> snapshot) {
        if (snapshot.hasError) {
          return Column(
            children: <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 12),
              Text('Unexpected error: ${snapshot.error}'),
              const SizedBox(height: 8),
              Text('Stack trace: ${snapshot.stackTrace}'),
            ],
          );
        }

        if (snapshot.connectionState != ConnectionState.waiting) {
          final Iterable<EntityState> states = snapshot.data!;
          for(final state in states) {
            if (state.requestStatus == RequestStatus.failed) {
              return Text(state.error!);
            }
          }

          if (states.every((state) => state.requestStatus == RequestStatus.succeed)) {
            return widget.builder(widget.data);
          }
        }

        // By default, show a loading spinner.
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}