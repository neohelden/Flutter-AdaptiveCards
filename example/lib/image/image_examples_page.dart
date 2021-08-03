import 'package:flutter/material.dart';

import '../brightness_switch.dart';
import '../loading_adaptive_card.dart';

/// Demonstrates the AdaptiveCardImage.
class ImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image"),
        actions: [
          BrightnessSwitch(),
        ],
      ),
      body: ListView(
        children: <Widget>[
          DemoAdaptiveCard("lib/image/example1.json"),
          DemoAdaptiveCard("lib/image/example2.json"),
          DemoAdaptiveCard("lib/image/example3.json"),
          DemoAdaptiveCard("lib/image/example4.json"),
          DemoAdaptiveCard("lib/image/example5.json"),
          DemoAdaptiveCard("lib/image/width_and_heigh_set_in_pixels.json"),
          DemoAdaptiveCard("lib/image/width_set_in_pixels.json"),
          DemoAdaptiveCard("lib/image/height_set_in_pixels.json"),
          DemoAdaptiveCard("lib/image/example0.json"),
        ],
      ),
    );
  }
}
