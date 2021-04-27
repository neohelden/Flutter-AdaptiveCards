import 'package:flutter/material.dart';

import '../flutter_adaptive_cards.dart';
import 'adaptive_card_element.dart';
import 'base.dart';
import 'containers/column_set.dart';
import 'containers/container.dart';
import 'containers/fact_set.dart';
import 'containers/image_set.dart';
import 'elements/action_set.dart';
import 'elements/actions/open_url.dart';
import 'elements/actions/show_card.dart';
import 'elements/actions/submit.dart';
import 'elements/image.dart';
import 'elements/media.dart';
import 'elements/text_block.dart';
import 'elements/unknown.dart';
import 'inputs/choice_set.dart';
import 'inputs/date.dart';
import 'inputs/number.dart';
import 'inputs/text.dart';
import 'inputs/time.dart';
import 'inputs/toggle.dart';

/// Crates a widget based on an configuration map.
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
/// Delete an element even if you have provided it yourself via the
/// [addedElements]
class CardRegistry {

  /// Creates a CardRegistry.
  const CardRegistry({
    this.removedElements = const [],
    this.addedElements = const {},
    this.addedActions = const {},
    this.supportMarkdown = true,
  });

  /// Provide custom elements to use.
  /// When providing an element which is already defined, it is overwritten
  final Map<String, ElementCreator> addedElements;

  /// Add custom actions to be added.
  final Map<String, ElementCreator> addedActions;

  /// Remove specific elements from the list
  final List<String> removedElements;

  /// Due to https://github.com/flutter/flutter_markdown/issues/171,
  /// markdown support doesn't work at the same time as content alignment
  /// in a column set
  final bool supportMarkdown;

  /// Get an AdaptiveElement from the map.
  Widget getElement(
    Map<String, dynamic> map, {
    String parentMode = "stretch",
    bool listView = false,
  }) {
    String? stringType = map["type"];

    if (removedElements.contains(stringType)) {
      return AdaptiveUnknown(
        type: stringType,
        adaptiveMap: map,
      );
    }

    if (addedElements.containsKey(stringType)) {
      return addedElements[stringType!]!(map);
    } else {
      return _getBaseElement(map,
          parentMode: parentMode,
          supportMarkdown: supportMarkdown,
          listView: listView);
    }
  }

  /// Gets an AdaptiveAction from the [map].
  GenericAction? getGenericAction(
    Map<String, dynamic> map,
    RawAdaptiveCardState? state,
  ) {
    String? stringType = map["type"];

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

  /// Gets an action from the [map].
  Widget getAction(Map<String, dynamic> map) {
    String? stringType = map["type"];

    if (removedElements.contains(stringType)) {
      return AdaptiveUnknown(
        adaptiveMap: map,
        type: stringType,
      );
    }

    if (addedActions.containsKey(stringType)) {
      return addedActions[stringType!]!(map);
    } else {
      return _getBaseAction(map);
    }
  }

  /// This returns an [AdaptiveElement] with the correct type.
  ///
  /// It looks at the [type] property and decides which object to construct
  Widget _getBaseElement(
    Map<String, dynamic> map, {
    String parentMode = "stretch",
    bool supportMarkdown = false,
    required bool listView,
  }) {
    String? stringType = map["type"];

    switch (stringType) {
      case "Media":
        return AdaptiveMedia(adaptiveMap: map);
      case "Container":
        return AdaptiveContainer(
          adaptiveMap: map,
        );
      case "TextBlock":
        return AdaptiveTextBlock(
          adaptiveMap: map,
          supportMarkdown: supportMarkdown,
        );
      case "ActionSet":
        return ActionSet(adaptiveMap: map);
      case "AdaptiveCard":
        return AdaptiveCardElement(
          adaptiveMap: map,
          useListView: listView,
        );
      case "ColumnSet":
        return AdaptiveColumnSet(
          adaptiveMap: map,
          supportMarkdown: supportMarkdown,
        );
      case "Image":
        return AdaptiveImage(
          adaptiveMap: map,
          parentMode: parentMode,
          supportMarkdown: supportMarkdown,
        );
      case "FactSet":
        return AdaptiveFactSet(
          adaptiveMap: map,
        );
      case "ImageSet":
        return AdaptiveImageSet(
            adaptiveMap: map, supportMarkdown: supportMarkdown);
      case "Input.Text":
        return AdaptiveTextInput(adaptiveMap: map);
      case "Input.Number":
        return AdaptiveNumberInput(adaptiveMap: map);
      case "Input.Date":
        return AdaptiveDateInput(
          adaptiveMap: map,
        );
      case "Input.Time":
        return AdaptiveTimeInput(
          adaptiveMap: map,
        );
      case "Input.Toggle":
        return AdaptiveToggle(
          adaptiveMap: map,
        );
      case "Input.ChoiceSet":
        return AdaptiveChoiceSet(
          adaptiveMap: map,
        );
    }
    return AdaptiveUnknown(
      adaptiveMap: map,
      type: stringType,
    );
  }

  Widget _getBaseAction(
    Map<String, dynamic> map,
  ) {
    String? stringType = map["type"];

    switch (stringType) {
      case "Action.ShowCard":
        return AdaptiveActionShowCard(
          adaptiveMap: map,
        );
      case "Action.OpenUrl":
        return AdaptiveActionOpenUrl(
          adaptiveMap: map,
        );
      case "Action.Submit":
        return AdaptiveActionSubmit(
          adaptiveMap: map,
        );
    }
    return AdaptiveUnknown(
      adaptiveMap: map,
      type: stringType,
    );
  }
}

/// The top level adaptive card registry.
class DefaultCardRegistry extends InheritedWidget {

  /// Creates a DefaultCardRegistry.
  DefaultCardRegistry({
    Key? key,
    required this.cardRegistry,
    required Widget child,
  }) : super(key: key, child: child);

  /// The card registry.
  final CardRegistry cardRegistry;

  /// Provides the DefaultCardRegistry via the context.
  static CardRegistry? of(BuildContext context) {
    var cardRegistry =
        context.dependOnInheritedWidgetOfExactType<DefaultCardRegistry>();
    if (cardRegistry == null) return null;
    return cardRegistry.cardRegistry;
  }

  @override
  bool updateShouldNotify(DefaultCardRegistry oldWidget) => oldWidget != this;
}
