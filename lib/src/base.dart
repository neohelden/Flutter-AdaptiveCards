import 'package:flutter/material.dart';
import 'package:flutter_adaptive_cards/flutter_adaptive_cards.dart';
import 'package:provider/provider.dart';

class InheritedReferenceResolver extends StatelessWidget {
  final Widget child;
  final ReferenceResolver resolver;

  const InheritedReferenceResolver({Key? key, required this.resolver, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<ReferenceResolver>.value(
      value: resolver,
      child: child,
    );
  }
}

mixin AdaptiveElementWidgetMixin on StatefulWidget {
  Map get adaptiveMap;
}

mixin AdaptiveElementMixin<T extends AdaptiveElementWidgetMixin> on State<T> {
  String? id;

  RawAdaptiveCardState? widgetState;

  Map get adaptiveMap => widget.adaptiveMap;

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
      identical(this, other) || other is AdaptiveElementMixin && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

mixin AdaptiveActionMixin<T extends AdaptiveElementWidgetMixin> on State<T> implements AdaptiveElementMixin<T> {
  String? get title => widget.adaptiveMap["title"];

  void onTapped();
}

mixin AdaptiveInputMixin<T extends AdaptiveElementWidgetMixin> on State<T> implements AdaptiveElementMixin<T> {
  String? value;

  @override
  void initState() {
    super.initState();
    value = adaptiveMap["value"].toString() == "null" ? "" : adaptiveMap["value"].toString();
  }

  void appendInput(Map? map);
}

mixin AdaptiveTextualInputMixin<T extends AdaptiveElementWidgetMixin> on State<T> implements AdaptiveInputMixin<T> {
  String? placeholder;

  @override
  void initState() {
    super.initState();

    placeholder = widget.adaptiveMap["placeholder"] ?? "";
  }
}

abstract class GenericAction {
  GenericAction(this.adaptiveMap, this.rawAdaptiveCardState);

  String? get title => adaptiveMap["title"];
  final Map adaptiveMap;
  final RawAdaptiveCardState? rawAdaptiveCardState;

  void tap();
}

class GenericSubmitAction extends GenericAction {
  GenericSubmitAction(Map adaptiveMap, RawAdaptiveCardState? rawAdaptiveCardState)
      : super(adaptiveMap, rawAdaptiveCardState) {
    data = adaptiveMap["data"] ?? {};
  }

  Map? data;

  @override
  void tap() {
    rawAdaptiveCardState!.submit(data);
  }
}

class GenericActionOpenUrl extends GenericAction {
  GenericActionOpenUrl(Map adaptiveMap, RawAdaptiveCardState? rawAdaptiveCardState)
      : super(adaptiveMap, rawAdaptiveCardState) {
    url = adaptiveMap["url"];
  }

  String? url;

  @override
  void tap() {
    rawAdaptiveCardState!.openUrl(url);
  }
}
