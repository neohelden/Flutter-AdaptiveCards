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
          DemoAdaptiveCard("lib/text_block/example1.json"),
          DemoAdaptiveCard("lib/text_block/example2.json"),
          DemoAdaptiveCard("lib/text_block/example3.json"),
          DemoAdaptiveCard("lib/text_block/example4.json"),
          DemoAdaptiveCard("lib/text_block/example5.json"),
          DemoAdaptiveCard("lib/text_block/example6.json"),
          DemoAdaptiveCard("lib/text_block/example7.json"),
          DemoAdaptiveCard("lib/text_block/example8.json"),
          DemoAdaptiveCard("lib/text_block/example9.json"),
          DemoAdaptiveCard("lib/text_block/example10.json"),
          DemoAdaptiveCard(
            "lib/text_block/example11.json",
            supportMarkdown: false,
          ),
        ],
      ),
    );
  }
}
