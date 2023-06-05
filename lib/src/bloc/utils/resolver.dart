import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'entity_state.dart';
import 'request_status.dart';
import 'entity_cubit.dart';

typedef BuilderParams = Map<String, Object>?;
typedef CubitFactory = EntityCubit Function();

class Resolver extends StatefulWidget {
  final Widget Function(BuilderParams data) builder;
  final CubitFactory cubitFactory;

  // potentially unnecessary param
  final BuilderParams data;
  
  // @param to prevent rebuilding on state change. useful for cases when we want to rebuild only particular widgets on the page (e.g. avoid flickering)
  final bool isBuiltOnce; 

  // @param to show spinner while resolver loads data from api
  final bool showSpinner; 

  const Resolver({ 
    super.key, 
    required this.cubitFactory, 
    required this.builder, 
    this.data,
    this.isBuiltOnce = false,
    this.showSpinner = true,
  });
  
  @override
  ResolverState createState() => ResolverState();
}

class ResolverState extends State<Resolver>{
  late final EntityCubit cubit;
  bool isBuilt = false;

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
        // TODO: consider passing error to page widget to display it in particular place there or showing error toastr
        if (state.requestStatus == RequestStatus.failed) {
          return Text(state.error!);
        }

        if (state.requestStatus == RequestStatus.succeed) {
          return widget.builder(widget.data);
        }

        // By default, show a loading spinner.
        return const Center(child: CircularProgressIndicator());
      },
      buildWhen: (EntityState previous, EntityState current) {
        if (!widget.showSpinner) {
          return current.requestStatus != RequestStatus.inProgress;

          // using loader_overlay lib instead of material progress indicator
          // if (current.requestStatus == RequestStatus.inProgress) {
          //   context.loaderOverlay.show();
          //   return false;
          // } else {
          //   context.loaderOverlay.hide();
          // }
        }

        if (!widget.isBuiltOnce) {
          return true;
        }

        if (!isBuilt) {
          isBuilt = true;
          return true;
        }

        return false;
      },
    );
  }
}