import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../additional.dart';
import '../base.dart';

class AdaptiveNumberInput extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveNumberInput({Key? key, required this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveNumberInputState createState() => _AdaptiveNumberInputState();
}

class _AdaptiveNumberInputState extends State<AdaptiveNumberInput>
    with AdaptiveTextualInputMixin, AdaptiveInputMixin, AdaptiveElementMixin {
  TextEditingController controller = TextEditingController();

  int? min;
  int? max;

  @override
  void initState() {
    super.initState();

    controller.text = value!;
    min = adaptiveMap["min"];
    max = adaptiveMap["max"];
  }

  @override
  Widget build(BuildContext context) {
    return SeparatorElement(
      adaptiveMap: adaptiveMap,
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: [
          TextInputFormatter.withFunction((oldVal, newVal) {
            if (newVal.text == "") return newVal;
            int newNumber = int.parse(newVal.text);
            if (newNumber >= min! && newNumber <= max!) return newVal;
            return oldVal;
          })
        ],
        controller: controller,
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
}
