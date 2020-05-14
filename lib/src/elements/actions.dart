import 'package:flutter/material.dart';
import 'package:flutter_adaptive_cards/flutter_adaptive_cards.dart';
import 'package:flutter_adaptive_cards/src/elements/base.dart';
import 'package:flutter_adaptive_cards/src/elements/basics.dart';

class ActionSet extends StatefulWidget with AdaptiveElementWidgetMixin {
  ActionSet({Key key, this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _ActionSetState createState() => _ActionSetState();
}

class _ActionSetState extends State<ActionSet> with AdaptiveElementMixin {
  List<Widget> actions = List();

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
    return Column(children: actions);
  }

  Widget _getAction(Map<String, dynamic> map) {
    String stringType = map["type"];

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

class IconButtonAction extends StatefulWidget with AdaptiveElementWidgetMixin {
  IconButtonAction({Key key, this.adaptiveMap, this.onTapped})
      : super(key: key);

  final Map adaptiveMap;

  final VoidCallback onTapped;

  @override
  _IconButtonActionState createState() => _IconButtonActionState();
}

class _IconButtonActionState extends State<IconButtonAction>
    with AdaptiveActionMixin, AdaptiveElementMixin {
  String iconUrl;

  @override
  void initState() {
    super.initState();
    iconUrl = adaptiveMap["iconUrl"];
  }

  @override
  Widget build(BuildContext context) {
    Widget result = RaisedButton(
      onPressed: onTapped,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center, children: [Text(title)]),
    );

    if (iconUrl != null) {
      result = RaisedButton.icon(
        onPressed: onTapped,
        icon: Image.network(
          iconUrl,
          height: 36.0,
        ),
        label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(title)]),
      );
    }
    return result;
  }

  @override
  void onTapped() => widget.onTapped();
}

class AdaptiveActionShowCard extends StatefulWidget
    with AdaptiveElementWidgetMixin {
  AdaptiveActionShowCard({Key key, this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveActionShowCardState createState() => _AdaptiveActionShowCardState();
}

class _AdaptiveActionShowCardState extends State<AdaptiveActionShowCard>
    with AdaptiveActionMixin, AdaptiveElementMixin {
  @override
  void initState() {
    super.initState();

    Widget card = widgetState.cardRegistry.getElement(adaptiveMap["card"]);

    var _adaptiveCardElement = AdaptiveCardElementState.of(context);
    if (_adaptiveCardElement != null) {
      _adaptiveCardElement.registerCard(id, card);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onTapped,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title),
          AdaptiveCardElementState.of(context).currentCardId == id
              ? Icon(Icons.keyboard_arrow_up)
              : Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  @override
  void onTapped() {
    var _adaptiveCardElement = AdaptiveCardElementState.of(context);
    if (_adaptiveCardElement != null) {
      _adaptiveCardElement.showCard(id);
    }
  }
}

class AdaptiveActionSubmit extends StatefulWidget
    with AdaptiveElementWidgetMixin {
  AdaptiveActionSubmit({Key key, this.adaptiveMap, this.color})
      : super(key: key);

  final Map adaptiveMap;

  // Native styling
  final Color color;

  @override
  _AdaptiveActionSubmitState createState() => _AdaptiveActionSubmitState();
}

class _AdaptiveActionSubmitState extends State<AdaptiveActionSubmit>
    with AdaptiveActionMixin, AdaptiveElementMixin {
  GenericSubmitAction action;

  @override
  void initState() {
    super.initState();
    action = GenericSubmitAction(adaptiveMap, widgetState);
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: widget.color,
      onPressed: onTapped,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(title)],
      ),
    );
  }

  @override
  void onTapped() {
    action.tap();
  }
}

class AdaptiveActionOpenUrl extends StatefulWidget
    with AdaptiveElementWidgetMixin {
  AdaptiveActionOpenUrl({Key key, this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveActionOpenUrlState createState() => _AdaptiveActionOpenUrlState();
}

class _AdaptiveActionOpenUrlState extends State<AdaptiveActionOpenUrl>
    with AdaptiveActionMixin, AdaptiveElementMixin {
  GenericActionOpenUrl action;
  String iconUrl;

  @override
  void initState() {
    super.initState();

    action = GenericActionOpenUrl(adaptiveMap, widgetState);
    iconUrl = adaptiveMap["iconUrl"];
  }

  @override
  Widget build(BuildContext context) {
    // TODO
    return IconButtonAction(
      adaptiveMap: adaptiveMap,
      onTapped: onTapped,
    );
  }

  @override
  void onTapped() {
    action.tap();
  }
}
