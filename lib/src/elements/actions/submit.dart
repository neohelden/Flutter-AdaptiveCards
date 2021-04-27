import 'package:flutter/material.dart';

import '../../base.dart';

// TODO: Allow color styling via the hostconfig.

/// A button which can trigger an sumbit action.
class AdaptiveActionSubmit extends StatefulWidget
    with AdaptiveElementWidgetMixin {

  /// Creates an AdaptiveActionSubmit widget.
  AdaptiveActionSubmit({
    Key? key,
    required this.adaptiveMap,
  }) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveActionSubmitState createState() => _AdaptiveActionSubmitState();
}

class _AdaptiveActionSubmitState extends State<AdaptiveActionSubmit>
    with AdaptiveActionMixin, AdaptiveElementMixin {

  late GenericSubmitAction action;

  @override
  void initState() {
    super.initState();
    action = GenericSubmitAction(adaptiveMap, widgetState);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTapped,
      child: Text(title!, textAlign: TextAlign.center),
    );
  }

  @override
  void onTapped() {
    action.tap();
  }
}
