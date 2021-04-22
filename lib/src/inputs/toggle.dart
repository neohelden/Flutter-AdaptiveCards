import 'package:flutter/material.dart';

import '../additional.dart';
import '../base.dart';

/// A toggle widget.
class AdaptiveToggle extends StatefulWidget with AdaptiveElementWidgetMixin {

  /// Creates an AdaptiveToggle widget.
  AdaptiveToggle({Key? key, required this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveToggleState createState() => _AdaptiveToggleState();
}

class _AdaptiveToggleState extends State<AdaptiveToggle>
    with AdaptiveInputMixin, AdaptiveElementMixin {

  bool boolValue = false;

  String? valueOff;
  String? valueOn;

  late String title;

  @override
  void initState() {
    super.initState();

    valueOff = adaptiveMap["valueOff"] ?? "false";
    valueOn = adaptiveMap["valueOn"] ?? "true";
    boolValue = value == valueOn;
    title = adaptiveMap["title"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return SeparatorElement(
      adaptiveMap: adaptiveMap,
      child: Row(
        children: <Widget>[
          Switch(
            value: boolValue,
            onChanged: (newValue) {
              setState(() {
                boolValue = newValue;
              });
            },
          ),
          Expanded(
            child: Text(title),
          ),
        ],
      ),
    );
  }

  @override
  void appendInput(Map? map) {
    map![id] = boolValue ? valueOn : valueOff;
  }
}
