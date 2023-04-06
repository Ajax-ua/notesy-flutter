import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'entity_state.dart';
import 'request_status.dart';
import 'entity_cubit.dart';

class Resolver extends StatefulWidget {
  final Widget Function(Map<String, Object>? data) builder;
  final Map<String, Object>? data;
  final EntityCubit Function() cubitFactory;

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
          return PlatformText(state.error!);
        }

        if (state.requestStatus == RequestStatus.succeed) {
          return widget.builder(widget.data);
        }

        // By default, show a loading spinner.
        return Center(child: PlatformCircularProgressIndicator());
      },
    );
  }
}