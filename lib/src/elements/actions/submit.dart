import 'package:flutter/material.dart';

import '../../base.dart';

class AdaptiveActionSubmit extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveActionSubmit({Key? key, required this.adaptiveMap, this.color}) : super(key: key);

  final Map adaptiveMap;

  // Native styling
  final Color? color;

  @override
  _AdaptiveActionSubmitState createState() => _AdaptiveActionSubmitState();
}

class _AdaptiveActionSubmitState extends State<AdaptiveActionSubmit> with AdaptiveActionMixin, AdaptiveElementMixin {
  late GenericSubmitAction action;

  @override
  void initState() {
    super.initState();
    action = GenericSubmitAction(adaptiveMap, widgetState);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: widget.color,
      ),
      onPressed: onTapped,
      child: Text(title!, textAlign: TextAlign.center),
    );
  }

  @override
  void onTapped() {
    action.tap();
  }
}
