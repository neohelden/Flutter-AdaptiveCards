import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../flutter_adaptive_cards.dart';

/// Provides the [resolver] to the [child].
class InheritedReferenceResolver extends StatelessWidget {

  /// The child which can access the resolver.
  final Widget child;

  /// The resolver inherited to the child.
  final ReferenceResolver resolver;

  /// Creates a InheritedReferenceResolver widget.
  const InheritedReferenceResolver({
    Key? key,
    required this.resolver,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<ReferenceResolver>.value(
      value: resolver,
      child: child,
    );
  }
}

/// Defines a widget as an AdaptiveCard widget element.
mixin AdaptiveElementWidgetMixin on StatefulWidget {

  /// The configuration of an AdaptiveCard widget element.
  Map get adaptiveMap;
}

/// Defines shared attributes of all adaptive elements.
mixin AdaptiveElementMixin<T extends AdaptiveElementWidgetMixin> on State<T> {
  /// The id of the element.
  String? id;

  /// The state of the element.
  RawAdaptiveCardState? widgetState;

  /// The content map of the widget.
  Map get adaptiveMap => widget.adaptiveMap;

  /// The reference resolver.
  ReferenceResolver? resolver;

  @override
  void initState() {
    super.initState();

    resolver = context.read<ReferenceResolver>();

    widgetState = context.read<RawAdaptiveCardState>();
    if (widget.adaptiveMap.containsKey("id")) {
      id = widget.adaptiveMap["id"];
    } else {
      id = widgetState!.idGenerator.getId();
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdaptiveElementMixin &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// A mixing for all adaptive card actions.
mixin AdaptiveActionMixin<T extends AdaptiveElementWidgetMixin> on State<T>
    implements AdaptiveElementMixin<T> {

  /// The title of the action.
  String? get title => widget.adaptiveMap["title"];

  /// The on tapped of the action.
  void onTapped();
}

/// A mixin for all user inputs.
mixin AdaptiveInputMixin<T extends AdaptiveElementWidgetMixin> on State<T>
    implements AdaptiveElementMixin<T> {

  /// The value of the input.
  String? value;

  @override
  void initState() {
    super.initState();
    value = adaptiveMap["value"].toString() == "null"
        ? ""
        : adaptiveMap["value"].toString();
  }

  /// Appends the input value to a map.
  void appendInput(Map? map);
}

/// A mixin for all text input fields.
mixin AdaptiveTextualInputMixin<T extends AdaptiveElementWidgetMixin>
    on State<T> implements AdaptiveInputMixin<T> {

  /// The placeholder of the input field.
  String? placeholder;

  @override
  void initState() {
    super.initState();

    placeholder = widget.adaptiveMap["placeholder"] ?? "";
  }
}

/// The base class an AdaptiveAction.
abstract class GenericAction {
  /// Creates an GenericAction.
  GenericAction(this.adaptiveMap, this.rawAdaptiveCardState);

  /// The title of the action.
  String? get title => adaptiveMap["title"];

  /// The configuration of the action.
  final Map adaptiveMap;

  /// The state of the action.
  final RawAdaptiveCardState? rawAdaptiveCardState;

  /// The function called when the action button is tapped.
  void tap();
}

/// Calls the submit callback when tap is called.
class GenericSubmitAction extends GenericAction {

  /// Creates a GenericSubmitAction.
  GenericSubmitAction(
      Map adaptiveMap, RawAdaptiveCardState? rawAdaptiveCardState)
      : super(adaptiveMap, rawAdaptiveCardState) {
    data = adaptiveMap["data"] ?? {};
  }

  /// The data which is send to the callback.
  Map? data;

  @override
  void tap() {
    rawAdaptiveCardState!.submit(data);
  }
}

/// Calls the openUrl callback when tap is called.
class GenericActionOpenUrl extends GenericAction {

  /// Creates a GenericActionOpenUrl.
  GenericActionOpenUrl(
      Map adaptiveMap, RawAdaptiveCardState? rawAdaptiveCardState)
      : super(adaptiveMap, rawAdaptiveCardState) {
    url = adaptiveMap["url"];
  }

  /// The url which is send to the callback.
  String? url;

  @override
  void tap() {
    rawAdaptiveCardState!.openUrl(url);
  }
}
