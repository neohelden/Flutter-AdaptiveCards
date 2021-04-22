import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../flutter_adaptive_cards.dart';
import 'base.dart';

/// Draws a separator line above the [child].
class SeparatorElement extends StatefulWidget with AdaptiveElementWidgetMixin {

  final Map adaptiveMap;

  /// The child of the
  final Widget child;

  /// Creates a SeparatorElement widget.
  SeparatorElement({
    Key? key,
    required this.adaptiveMap,
    required this.child,
  }) : super(key: key);

  @override
  _SeparatorElementState createState() => _SeparatorElementState();
}

class _SeparatorElementState extends State<SeparatorElement>
    with AdaptiveElementMixin {

  double? topSpacing;
  late bool separator;

  @override
  void initState() {
    super.initState();
    topSpacing = resolver!.resolveSpacing(adaptiveMap["spacing"]);
    separator = adaptiveMap["separator"] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        separator ? Divider(height: topSpacing) : SizedBox(height: topSpacing),
        widget.child,
      ],
    );
  }
}

/// Handles tap actions on the [child].
class AdaptiveTappable extends StatefulWidget with AdaptiveElementWidgetMixin {

  /// Creates an AdaptiveTappable widget.
  AdaptiveTappable({
    Key? key,
    required this.child,
    required this.adaptiveMap,
  }) : super(key: key);

  /// The child which can be tapped on.
  final Widget child;

  final Map adaptiveMap;

  @override
  _AdaptiveTappableState createState() => _AdaptiveTappableState();
}

class _AdaptiveTappableState extends State<AdaptiveTappable>
    with AdaptiveElementMixin {
  GenericAction? action;

  @override
  void initState() {
    super.initState();
    if (adaptiveMap.containsKey("selectAction")) {
      action = widgetState!.cardRegistry
          .getGenericAction(adaptiveMap["selectAction"], widgetState);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action?.tap,
      child: widget.child,
    );
  }
}

/// Provides the configured style of the [adaptiveMap] as top level container
/// style to the [child].
class ChildStyler extends StatelessWidget {
  /// The style provided child.
  final Widget child;

  /// The widget configuration.
  final Map adaptiveMap;

  /// Creates a ChildStyler widget.
  const ChildStyler({
    Key? key,
    required this.child,
    required this.adaptiveMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InheritedReferenceResolver(
      resolver: context
          .watch<ReferenceResolver>()
          .copyWith(style: adaptiveMap["style"]),
      child: child,
    );
  }
}
