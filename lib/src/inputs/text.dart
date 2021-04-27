import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../additional.dart';
import '../base.dart';

/// A text input field.
class AdaptiveTextInput extends StatefulWidget with AdaptiveElementWidgetMixin {

  /// Creates an AdaptiveTextInput widget.
  AdaptiveTextInput({Key? key, required this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveTextInputState createState() => _AdaptiveTextInputState();
}

class _AdaptiveTextInputState extends State<AdaptiveTextInput>
    with AdaptiveTextualInputMixin, AdaptiveInputMixin, AdaptiveElementMixin {

  TextEditingController controller = TextEditingController();
  late bool isMultiline;
  int? maxLength;
  TextInputType? style;

  @override
  void initState() {
    super.initState();
    isMultiline = adaptiveMap["isMultiline"] ?? false;
    maxLength = adaptiveMap["maxLength"];
    style = loadTextInputType();
    controller.text = value!;
  }

  @override
  Widget build(BuildContext context) {
    return SeparatorElement(
      adaptiveMap: adaptiveMap,
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        keyboardType: style,
        maxLines: isMultiline ? null : 1,
        decoration: InputDecoration(
          labelText: placeholder,
        ),
      ),
    );
  }

  @override
  void appendInput(Map? map) {
    map![id] = controller.text;
  }

  TextInputType? loadTextInputType() {
    /// Can be one of the following:
    /// - "text"
    /// - "tel"
    /// - "url"
    /// - "email"
    String style = adaptiveMap["style"] ?? "text";
    switch (style) {
      case "text":
        return TextInputType.text;
      case "tel":
        return TextInputType.phone;
      case "url":
        return TextInputType.url;
      case "email":
        return TextInputType.emailAddress;
      default:
        return null;
    }
  }
}
