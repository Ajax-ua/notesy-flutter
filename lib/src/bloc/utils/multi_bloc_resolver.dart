import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'entity_state.dart';
import 'request_status.dart';
import 'entity_cubit.dart';

typedef BuilderParams = Map<String, Object>?;

class MultiBlocResolver extends StatefulWidget {
  final Widget Function(BuilderParams data) builder;
  final Iterable<EntityCubit Function()> cubitFactories;

    // potentially unnecessary param
  final BuilderParams data;
  
  // @param to prevent rebuilding on state change. useful for cases when we want to rebuild only particular widgets on the page (e.g. avoid flickering)
  final bool isBuiltOnce; 

  // @param to show spinner while resolver loads data from api
  final bool showSpinner; 

  const MultiBlocResolver({ 
    super.key, 
    required this.cubitFactories, 
    required this.builder, 
    this.data,
    this.isBuiltOnce = false,
    this.showSpinner = true,
  });
  
  @override
  MultiBlocResolverState createState() => MultiBlocResolverState();
}

class MultiBlocResolverState extends State<MultiBlocResolver>{
  late final Stream<Iterable<EntityState>>combinedStream$;

  @override
  void initState() {
    final cubits = widget.cubitFactories.map((cf) => cf());
    Iterable<Stream<EntityState>> streams = cubits.map((cubit) {
      // startWith added for the cases when state emit is performed before StreamBuilder starts to listen to it
      return cubit.stream.startWith(cubit.state);
    });
    if (widget.isBuiltOnce) {
      streams = streams.map((stream) {
        return stream.where((state) {
          return state.requestStatus == RequestStatus.succeed;
        }).take(1);
      });
    }
    combinedStream$ = CombineLatestStream.list(streams);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: combinedStream$,
      builder: (BuildContext context, AsyncSnapshot<Iterable<EntityState>> snapshot) {
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

        const loader = Center(child: CircularProgressIndicator());
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loader;
        }
        
        if (widget.showSpinner) {
          final Iterable<EntityState> states = snapshot.data!;
          for (final state in states) {
            if (state.requestStatus == RequestStatus.inProgress) {
              return loader;
            }
          }
        }

        // TODO: consider passing error to page widget to display it in particular place there or showing error toastr
        final Iterable<EntityState> states = snapshot.data!;
        for (final state in states) {
          if (state.requestStatus == RequestStatus.failed) {
            return Text(state.error!);
          }
        }

        return widget.builder(widget.data);
      },
    );
  }
}