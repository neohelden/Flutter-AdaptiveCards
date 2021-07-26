import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base.dart';
import 'elements/actions/show_card.dart';
import 'elements/image/cross_network_image.dart';

/// A top level AdaptiveCard widget.
class AdaptiveCardElement extends StatefulWidget
    with AdaptiveElementWidgetMixin {
  /// Creates an AdaptiveCardElement widget.
  AdaptiveCardElement({
    Key? key,
    required this.adaptiveMap,
    required this.useListView,
  }) : super(key: UniqueKey());

  /// The map of the element.
  final Map adaptiveMap;

  /// Whether the children use a scrollable ListView instead of a Column.
  ///
  /// Set false if the element is already wrapped in a scrollable container.
  final bool useListView;

  @override
  AdaptiveCardElementState createState() => AdaptiveCardElementState();
}

/// The state of a top level AdaptiveCard widget.
class AdaptiveCardElementState extends State<AdaptiveCardElement>
    with AdaptiveElementMixin {
  /// The id of the adaptive card
  String? currentCardId;

  late List<Widget> _children;

  List<Widget> _allActions = [];

  List<AdaptiveActionShowCard> _showCardActions = [];

  // ignore: unused_field
  List<Widget> _cardsToShow = [];

  Axis? _actionsOrientation;

  String? _backgroundImage;

  final Map<String?, Widget> _registeredCards = {};

  /// Registers a card widget on the adaptive card.
  void registerCard(String? id, Widget it) {
    _registeredCards[id] = it;
  }

  @override
  void initState() {
    super.initState();

    String stringAxis = resolver!.resolve("actions", "actionsOrientation");
    if (stringAxis == "Horizontal") {
      _actionsOrientation = Axis.horizontal;
    } else if (stringAxis == "Vertical") {
      _actionsOrientation = Axis.vertical;
    }

    if (adaptiveMap["body"] != null) {
      _children = List<Map>.from(adaptiveMap["body"]).map((child) {
        return widgetState!.cardRegistry
            .getElement(child as Map<String, dynamic>);
      }).toList();
    } else {
      _children = [];
    }

    _backgroundImage = adaptiveMap['backgroundImage'];
  }

  void _loadChildren() {
    if (widget.adaptiveMap.containsKey("actions")) {
      _allActions = List<Map>.from(widget.adaptiveMap["actions"])
          .map((adaptiveMap) => widgetState!.cardRegistry
              .getAction(adaptiveMap as Map<String, dynamic>))
          .toList();

      _showCardActions = List<AdaptiveActionShowCard>.from(
          _allActions.whereType<AdaptiveActionShowCard>().toList());

      _cardsToShow = List<Widget>.from(_showCardActions
          .map((action) =>
              widgetState!.cardRegistry.getElement(action.adaptiveMap["card"]))
          .toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadChildren();
    List<Widget?> widgetChildren = _children.map((element) => element).toList();
    Widget actionWidget;
    if (_actionsOrientation == Axis.vertical) {
      List<Widget> actionWidgets = _allActions.map((action) {
        return SizedBox(
          width: double.infinity,
          child: action,
        );
      }).toList();

      actionWidget = Row(children: [
        Expanded(
          child: Column(
            children: actionWidgets,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        )
      ]);
    } else {
      List<Widget> actionWidgets = _allActions.map((action) {
        return Padding(
          padding: EdgeInsets.only(right: 8),
          child: action,
        );
      }).toList();

      actionWidget = Row(
        children: actionWidgets,
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    }
    widgetChildren.add(actionWidget);

    if (currentCardId != null) {
      widgetChildren.add(_registeredCards[currentCardId]);
    }

    Widget result = Padding(
      padding: const EdgeInsets.all(8.0),
      child: widget.useListView == true
          ? ListView(
              shrinkWrap: true,
              children: widgetChildren as List<Widget>,
            )
          : Column(
              children: widgetChildren as List<Widget>,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
    );

    if (_backgroundImage != null) {
      result = Stack(
        children: <Widget>[
          Positioned.fill(
            child: CrossNetworkImage(url: _backgroundImage!),
          ),
          result,
        ],
      );
    }

    return Provider<AdaptiveCardElementState>.value(
      value: this,
      child: result,
    );
  }

  /// This is called when an [_AdaptiveActionShowCard] triggers it.
  void showCard(String? id) {
    if (currentCardId == id) {
      currentCardId = null;
    } else {
      currentCardId = id;
    }
    setState(() {});
  }
}
