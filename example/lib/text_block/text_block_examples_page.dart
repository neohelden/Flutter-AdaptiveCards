import 'package:flutter/material.dart';

import '../brightness_switch.dart';
import '../loading_adaptive_card.dart';

/// Demonstrates a AdaptiveTextBlock.
class TextBlockPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TextBlock"),
        actions: [
          BrightnessSwitch(),
        ],
      ),
      body: ListView(
        children: <Widget>[
          DemoAdaptiveCard("lib/text_block/everything.json"),
          DemoAdaptiveCard("lib/text_block/colors.json"),
          DemoAdaptiveCard("lib/text_block/weight_and_horizontalAlignment.json"),
          DemoAdaptiveCard("lib/text_block/isSubtle.json"),
          DemoAdaptiveCard("lib/text_block/wrap_and_maxLines.json"),
          DemoAdaptiveCard("lib/text_block/size.json"),
          DemoAdaptiveCard("lib/text_block/weight.json"),
          DemoAdaptiveCard("lib/text_block/wrap.json"),
          DemoAdaptiveCard("lib/text_block/spacing.json"),
          DemoAdaptiveCard("lib/text_block/markdown.json"),
          DemoAdaptiveCard(
            "lib/text_block/horizontalAlignment.json",
            supportMarkdown: false,
          ),
        ],
      ),
    );
  }
}
