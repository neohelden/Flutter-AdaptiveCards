import 'package:flutter/material.dart';

/// Allows listening to actions triggered by AdaptiveCards lower in the
/// widget tree.
class DefaultAdaptiveCardHandlers extends InheritedWidget {

  /// Creates an DefaultAdaptiveCardHandlers widget.
  DefaultAdaptiveCardHandlers({
    Key? key,
    required this.onSubmit,
    required this.onOpenUrl,
    required Widget child,
  }) : super(key: key, child: child);

  /// Called when a action is submitted.
  final Function(Map? map) onSubmit;

  /// Called when a url should be opened.
  final Function(String? url) onOpenUrl;

  /// Returns a DefaultAdaptiveCardHandlers registered in the [context].
  static DefaultAdaptiveCardHandlers? of(BuildContext context) {
    var handlers = context
        .dependOnInheritedWidgetOfExactType<DefaultAdaptiveCardHandlers>();
    if (handlers == null) return null;
    return handlers;
  }

  @override
  bool updateShouldNotify(DefaultAdaptiveCardHandlers oldWidget) =>
      oldWidget != this;
}
