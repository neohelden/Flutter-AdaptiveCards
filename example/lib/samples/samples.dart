import 'package:flutter/material.dart';

import '../brightness_switch.dart';
import '../loading_adaptive_card.dart';

/// Demonstrates the default adaptive card samples.
class SamplesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Samples"),
        actions: [
          BrightnessSwitch(),
        ],
      ),
      body: ListView(
        children: [
          DemoAdaptiveCard("lib/samples/activity_update.json"),
          DemoAdaptiveCard("lib/samples/calender_reminder.json"),
          DemoAdaptiveCard("lib/samples/flight_itinerary.json"),
          DemoAdaptiveCard("lib/samples/flight_update.json"),
          DemoAdaptiveCard("lib/samples/food_order.json"),
          DemoAdaptiveCard("lib/samples/image_gallery.json"),
          DemoAdaptiveCard("lib/samples/input_form.json"),
          DemoAdaptiveCard("lib/samples/inputs.json"),
          DemoAdaptiveCard("lib/samples/restaurant.json"),
          DemoAdaptiveCard("lib/samples/spider.json"),
          DemoAdaptiveCard("lib/samples/sporting_event.json"),
          DemoAdaptiveCard("lib/samples/stock_update.json"),
          DemoAdaptiveCard("lib/samples/weather_compact.json"),
          DemoAdaptiveCard("lib/samples/weather_large.json"),
          DemoAdaptiveCard("lib/samples/product_video.json"),
        ],
      ),
    );
  }
}
