import 'dart:ui';

import 'package:flutter/material.dart';

class InsertModal extends ModalRoute {
  final int issueNumber;
  InsertModal({
    RouteSettings? settings,
    ImageFilter? filter,
    required this.issueNumber,
  }) : super(filter: filter, settings: settings);

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.6);

  @override
  String? get barrierLabel => null;

  @override
  bool get barrierDismissible => true;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return const Scaffold(
      
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: Column(
          children: [Text("prova")],
        ),
      ),
    );
  }
}
