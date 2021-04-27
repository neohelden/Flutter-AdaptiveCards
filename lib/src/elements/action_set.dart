import 'package:flutter/material.dart';

import '../base.dart';
import 'actions/open_url.dart';
import 'actions/show_card.dart';
import 'actions/submit.dart';
import 'unknown.dart';

/// Displays row of adaptive actions.
class ActionSet extends StatefulWidget with AdaptiveElementWidgetMixin {

  /// Creates an ActionSet widget.
  ActionSet({Key? key, required this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _ActionSetState createState() => _ActionSetState();
}

class _ActionSetState extends State<ActionSet> with AdaptiveElementMixin {
  List<Widget> actions = [];

  @override
  void initState() {
    super.initState();
    List? actionMaps = adaptiveMap["actions"];
    if (actionMaps != null) {
      for (var action in actionMaps) {
        actions.add(_getAction(action));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 8.0, children: actions);
  }

  Widget _getAction(Map<String, dynamic> map) {
    String? stringType = map["type"];

    switch (stringType) {
      case "Action.ShowCard":
        return AdaptiveActionShowCard(adaptiveMap: map);
      case "Action.OpenUrl":
        return AdaptiveActionOpenUrl(adaptiveMap: map);
      case "Action.Submit":
        return AdaptiveActionSubmit(adaptiveMap: map);
    }
    return AdaptiveUnknown(adaptiveMap: map, type: stringType);
  }
}
