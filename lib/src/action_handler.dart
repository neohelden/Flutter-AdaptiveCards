import 'package:flutter/material.dart';

class DefaultAdaptiveCardHandlers extends InheritedWidget {
  DefaultAdaptiveCardHandlers ({
    Key? key,
    required this.onSubmit,
    required this.onOpenUrl,
    required Widget child,
  }) : super(key: key, child: child);

  final Function(Map? map) onSubmit;
  final Function(String? url) onOpenUrl;

  static DefaultAdaptiveCardHandlers? of(BuildContext context) {
    DefaultAdaptiveCardHandlers? handlers = context.dependOnInheritedWidgetOfExactType<DefaultAdaptiveCardHandlers>();
    if(handlers == null) return null;
    return handlers;
  }
  @override
  bool updateShouldNotify(DefaultAdaptiveCardHandlers oldWidget) => oldWidget != this;
}