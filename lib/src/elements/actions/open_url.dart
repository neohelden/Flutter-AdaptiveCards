import 'package:flutter/material.dart';

import '../../base.dart';
import 'icon_button.dart';

class AdaptiveActionOpenUrl extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveActionOpenUrl({Key? key, required this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveActionOpenUrlState createState() => _AdaptiveActionOpenUrlState();
}

class _AdaptiveActionOpenUrlState extends State<AdaptiveActionOpenUrl> with AdaptiveActionMixin, AdaptiveElementMixin {
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
