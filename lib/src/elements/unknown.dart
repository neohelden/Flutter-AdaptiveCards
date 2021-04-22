import 'package:flutter/material.dart';

import '../base.dart';

/// Element for an unknown type
///
/// This Element is returned when an unknown element type is encountered.
///
/// When in production, these are blank elements which don't render anything.
///
/// In debug mode these contain an error message describing the problem.
class AdaptiveUnknown extends StatefulWidget with AdaptiveElementWidgetMixin {

  /// Creates an AdaptiveUnknown widget.
  AdaptiveUnknown({
    Key? key,
    required this.adaptiveMap,
    this.type,
  }) : super(key: key);

  final Map adaptiveMap;

  /// The type of the unknown widget.
  final String? type;

  @override
  _AdaptiveUnknownState createState() => _AdaptiveUnknownState();
}

class _AdaptiveUnknownState extends State<AdaptiveUnknown>
    with AdaptiveElementMixin {

  @override
  Widget build(BuildContext context) {
    Widget result = SizedBox();

    // Only do this in debug mode
    assert(() {
      result = ErrorWidget("Type ${widget.type} not found. \n\n"
          "Because of this, a portion of the tree was dropped: \n"
          "$adaptiveMap");

      return true;
    }());

    return result;
  }
}
