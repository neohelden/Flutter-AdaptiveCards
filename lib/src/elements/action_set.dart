import 'package:flutter/material.dart';
import 'package:flutter_adaptive_cards/src/base.dart';
import 'package:flutter_adaptive_cards/src/elements/unknown.dart';
import 'actions/open_url.dart';
import 'actions/show_card.dart';
import 'actions/submit.dart';

class ActionSet extends StatefulWidget with AdaptiveElementWidgetMixin {
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
    List actionMaps = adaptiveMap["actions"];
    actionMaps.forEach((action) {
      actions.add(_getAction(action));
    });
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











