import 'package:flutter/material.dart';

import '../additional.dart';
import '../base.dart';
import '../utils.dart';

/// A styled container for an AdaptiveElement child.
class AdaptiveContainer extends StatefulWidget with AdaptiveElementWidgetMixin {

  /// Creates an AdaptiveContainer widget.
  AdaptiveContainer({Key? key, required this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveContainerState createState() => _AdaptiveContainerState();
}

class _AdaptiveContainerState extends State<AdaptiveContainer>
    with AdaptiveElementMixin {
// TODO implement verticalContentAlignment
  late List<Widget> children;

  @override
  void initState() {
    super.initState();
    if (adaptiveMap["items"] != null) {
      children = List<Map>.from(adaptiveMap["items"]).map((child) {
        return widgetState!.cardRegistry.getElement(
          child as Map<String, dynamic>,
        );
      }).toList();
    } else {
      children = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    var backgroundColor =
        getBackgroundColorIfNoBackgroundImageAndNoDefaultStyle(
      resolver: resolver,
      adaptiveMap: adaptiveMap,
      approximateDarkThemeColors:
          widgetState!.widget.approximateDarkThemeColors,
      brightness: Theme.of(context).brightness,
    );

    return ChildStyler(
      adaptiveMap: adaptiveMap,
      child: AdaptiveTappable(
        adaptiveMap: adaptiveMap,
        child: SeparatorElement(
          adaptiveMap: adaptiveMap,
          child: Container(
            color: backgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: children.toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
