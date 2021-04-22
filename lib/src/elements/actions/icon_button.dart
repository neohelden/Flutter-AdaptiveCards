import 'package:flutter/material.dart';

import '../../base.dart';

class IconButtonAction extends StatefulWidget with AdaptiveElementWidgetMixin {
  IconButtonAction({Key? key, required this.adaptiveMap, this.onTapped}) : super(key: key);

  final Map adaptiveMap;

  final VoidCallback? onTapped;

  @override
  _IconButtonActionState createState() => _IconButtonActionState();
}

class _IconButtonActionState extends State<IconButtonAction> with AdaptiveActionMixin, AdaptiveElementMixin {
  String? iconUrl;

  @override
  void initState() {
    super.initState();
    iconUrl = adaptiveMap["iconUrl"];
  }

  @override
  Widget build(BuildContext context) {
    Widget result = ElevatedButton(
      onPressed: onTapped,
      child: Text(title!),
    );

    if (iconUrl != null) {
      result = ElevatedButton.icon(
        onPressed: onTapped,
        icon: Image.network(
          iconUrl!,
          height: 36.0,
        ),
        label: Text(title!),
      );
    }
    return result;
  }

  @override
  void onTapped() => widget.onTapped!();
}
