import 'package:flutter/material.dart';

import '../brightness_switch.dart';
import '../loading_adaptive_card.dart';

/// Demonstrates the AdaptiveColumn.
class ColumnPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Column"),
        actions: [
          BrightnessSwitch(),
        ],
      ),
      body: ListView(
        children: <Widget>[
          DemoAdaptiveCard("lib/column/default.json"),
          DemoAdaptiveCard("lib/column/open_url_action.json"),
          DemoAdaptiveCard("lib/column/style.json"),
          DemoAdaptiveCard("lib/column/width_auto_stretch_auto.json"),
          DemoAdaptiveCard("lib/column/width_in_pixels.json"),
          DemoAdaptiveCard("lib/column/width_weighted.json"),
          DemoAdaptiveCard("lib/column/background_image.json"),
          DemoAdaptiveCard("lib/column/separator_and_spacing.json"),
          DemoAdaptiveCard(
            "lib/column/alignment_images.json",
            supportMarkdown: false,
          ),
          DemoAdaptiveCard(
            "lib/column/alignment_text.json",
            supportMarkdown: false,
          ),
        ],
      ),
    );
  }
}
