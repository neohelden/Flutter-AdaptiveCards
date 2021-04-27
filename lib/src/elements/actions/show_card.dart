import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../adaptive_card_element.dart';
import '../../base.dart';

/// An action to switch between cards.
class AdaptiveActionShowCard extends StatefulWidget
    with AdaptiveElementWidgetMixin {

  /// Creates an AdaptiveActionShowCard widget.
  AdaptiveActionShowCard({Key? key, required this.adaptiveMap})
      : super(key: key);

  /// The widget configuration.
  final Map adaptiveMap;

  @override
  _AdaptiveActionShowCardState createState() => _AdaptiveActionShowCardState();
}

class _AdaptiveActionShowCardState extends State<AdaptiveActionShowCard>
    with AdaptiveActionMixin, AdaptiveElementMixin {

  @override
  void initState() {
    super.initState();

    var card = widgetState!.cardRegistry.getElement(adaptiveMap["card"]);

    var _adaptiveCardElement = context.read<AdaptiveCardElementState>();
    _adaptiveCardElement.registerCard(id, card);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTapped,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(title!),
          context.watch<AdaptiveCardElementState>().currentCardId == id
              ? Icon(Icons.keyboard_arrow_up)
              : Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  @override
  void onTapped() {
    var _adaptiveCardElement = context.read<AdaptiveCardElementState>();
    _adaptiveCardElement.showCard(id);
  }
}
