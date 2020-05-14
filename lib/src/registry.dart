import 'package:flutter/material.dart';
import 'package:flutter_adaptive_cards/src/elements/actions.dart';
import 'package:flutter_adaptive_cards/src/elements/base.dart';
import 'package:flutter_adaptive_cards/src/elements/basics.dart';
import 'package:flutter_adaptive_cards/src/elements/input.dart';
import 'package:flutter_adaptive_cards/src/flutter_adaptive_cards.dart';

typedef ElementCreator = Widget Function(Map<String, dynamic> map);

/// Entry point for registering adaptive cards
///
/// 1. Providing custom elements
/// Add the element to [addedElements]. It takes the name of the element
/// as its key and it takes a function which generates an [AdaptiveElement] with
/// a given map and a widgetState
///
/// 2. Overwriting custom elements
/// Just use the same name as the element you want to override
///
/// 3. Deleting existing elements
///
/// Delete an element even if you have provided it yourself via the [addedElements]
///
class CardRegistry {
  const CardRegistry({
    this.removedElements = const [],
    this.addedElements = const {},
    this.addedActions = const {},
  });

  /// Provide custom elements to use.
  /// When providing an element which is already defined, it is overwritten
  final Map<String, ElementCreator> addedElements;

  final Map<String, ElementCreator> addedActions;

  /// Remove specific elements from the list
  final List<String> removedElements;

  Widget getElement(Map<String, dynamic> map) {
    String stringType = map["type"];

    if (removedElements.contains(stringType))
      return AdaptiveUnknown(
        type: stringType,
        adaptiveMap: map,
      );

    if (addedElements.containsKey(stringType)) {
      return addedElements[stringType](map);
    } else {
      return _getBaseElement(map);
    }
  }

  GenericAction getGenericAction(
    Map<String, dynamic> map,
    RawAdaptiveCardState state,
  ) {
    String stringType = map["type"];

    switch (stringType) {
      case "Action.ShowCard":
        assert(false,
            "Action.ShowCard can only be used directly by the root card");
        return null;
      case "Action.OpenUrl":
        return GenericActionOpenUrl(map, state);
      case "Action.Submit":
        return GenericSubmitAction(map, state);
    }
    assert(false, "No action found with type $stringType");
    return null;
  }

  Widget getAction(Map<String, dynamic> map) {
    String stringType = map["type"];

    if (removedElements.contains(stringType))
      return AdaptiveUnknown(
        adaptiveMap: map,
        type: stringType,
      );

    if (addedActions.containsKey(stringType)) {
      return addedActions[stringType](map);
    } else {
      return _getBaseAction(map);
    }
  }

  /// This returns an [AdaptiveElement] with the correct type.
  ///
  /// It looks at the [type] property and decides which object to construct
  Widget _getBaseElement(Map<String, dynamic> map) {
    String stringType = map["type"];

    switch (stringType) {
      case "Media":
        return AdaptiveMedia(adaptiveMap: map);
      case "Container":
        return AdaptiveContainer(adaptiveMap: map);
      case "TextBlock":
        return AdaptiveTextBlock(adaptiveMap: map);
      case "ActionSet":
        return ActionSet(adaptiveMap: map);
      case "AdaptiveCard":
        return AdaptiveCardElement(adaptiveMap: map);
      case "ColumnSet":
        return AdaptiveColumnSet(adaptiveMap: map);
      case "Image":
        return AdaptiveImage(adaptiveMap: map);
      case "FactSet":
        return AdaptiveFactSet(adaptiveMap: map);
      case "ImageSet":
        return AdaptiveImageSet(adaptiveMap: map);
      case "Input.Text":
        return AdaptiveTextInput(adaptiveMap: map);
      case "Input.Number":
        return AdaptiveNumberInput(adaptiveMap: map);
      case "Input.Date":
        return AdaptiveDateInput(adaptiveMap: map);
      case "Input.Time":
        return AdaptiveTimeInput(adaptiveMap: map);
      case "Input.Toggle":
        return AdaptiveToggle(adaptiveMap: map);
      case "Input.ChoiceSet":
        return AdaptiveChoiceSet(adaptiveMap: map);
    }
    return AdaptiveUnknown(adaptiveMap: map, type: stringType);
  }

  Widget _getBaseAction(Map<String, dynamic> map) {
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

class DefaultCardRegistry extends InheritedWidget {
  DefaultCardRegistry({
    Key key,
    @required this.cardRegistry,
    @required Widget child,
  }) : super(key: key, child: child);

  final CardRegistry cardRegistry;

  static CardRegistry of(BuildContext context) {
    DefaultCardRegistry cardRegistry =
        context.inheritFromWidgetOfExactType(DefaultCardRegistry);
    if (cardRegistry == null) return null;
    return cardRegistry.cardRegistry;
  }

  @override
  bool updateShouldNotify(DefaultCardRegistry oldWidget) => oldWidget != this;
}
