import 'package:flutter/material.dart';

Widget authBuilder (context, state, child) {
  return Theme(
    data: ThemeData.dark().copyWith(
      colorScheme: const ColorScheme.dark().copyWith(
        primary: Colors.white
      ),
    ),
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Notesy'),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(width: 300, height: 400, child: child),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    ),
  );
}
