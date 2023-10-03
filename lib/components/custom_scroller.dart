import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

class CustomScroller extends StatefulWidget {
  final Widget child;
  final int totalAmount;
  final Function(int?)? titleBuilder;
  final ScrollController _scrollController;

  CustomScroller({
    super.key,
    required this.child,
    required this.totalAmount,
    scrollController,
    this.titleBuilder,
  }) : _scrollController = scrollController ?? ScrollController();

  @override
  State<CustomScroller> createState() => _CustomScrollerState();
}

class _CustomScrollerState extends State<CustomScroller> {
  int? _currentElement;
  Timer? _visibilityTimer;
  bool _overlayVisible = false;

  void scrollListener() async {
    if (widget._scrollController.position.userScrollDirection ==
        ScrollDirection.idle) {
      final pos = widget._scrollController.position;
      final index =
          (pos.pixels / pos.maxScrollExtent * (widget.totalAmount - 1)).round();
      _visibilityTimer?.cancel(); // Reset timer if already started
      setState(() {
        _currentElement = index;

        _overlayVisible = true; // Show overlay
      });
      _visibilityTimer = Timer(
        const Duration(seconds: 1),
        () => setState(
          () => _overlayVisible = false, // Hide overlay after n seconds
        ),
      );
    }
  }

  @override
  void initState() {
    widget._scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    widget._scrollController.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        RawScrollbar(
          interactive: true,
          thumbVisibility: false,
          thickness: 15.0,
          crossAxisMargin: 5.0,
          radius: const Radius.circular(10.0),
          minThumbLength: 50.0,
          controller: widget._scrollController,
          child: widget.child,
        ),
        IgnorePointer(
          child: Center(
            child: AnimatedOpacity(
              opacity: _overlayVisible ? 0.8 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey[400],
                ),
                child: SizedBox.square(
                  dimension: 150.0,
                  child: Center(
                      child: Text(
                    widget.titleBuilder?.call(_currentElement).toString() ??
                        _currentElement.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: Colors.white),
                  )),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
