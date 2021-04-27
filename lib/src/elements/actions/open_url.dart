import 'package:flutter/material.dart';

import '../../base.dart';
import 'icon_button.dart';

/// Displays a button which calls an openUrl callback.
///
/// The callback has to be handled by an DefaultAdaptiveCardHandlers.
class AdaptiveActionOpenUrl extends StatefulWidget
    with AdaptiveElementWidgetMixin {

  /// Creates an AdaptiveActionOpenUrl widget.
  AdaptiveActionOpenUrl({
    Key? key,
    required this.adaptiveMap,
  }) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveActionOpenUrlState createState() => _AdaptiveActionOpenUrlState();
}

class _AdaptiveActionOpenUrlState extends State<AdaptiveActionOpenUrl>
    with AdaptiveActionMixin, AdaptiveElementMixin {

  late GenericActionOpenUrl action;
  String? iconUrl;

  @override
  void initState() {
    super.initState();

    action = GenericActionOpenUrl(adaptiveMap, widgetState);
    iconUrl = adaptiveMap["iconUrl"];
  }

  @override
  Widget build(BuildContext context) {
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
