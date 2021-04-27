import 'package:flutter/material.dart';
import 'package:flutter_adaptive_cards/flutter_adaptive_cards.dart';

import '../brightness_switch.dart';

/// Demonstrates a huge list with multiple adaptive cards to see the performance
/// in a scrollable list.
class RenderTimePage extends StatefulWidget {
  @override
  _RenderTimePageState createState() => _RenderTimePageState();
}

class _RenderTimePageState extends State<RenderTimePage> {
  late Map<String, dynamic> content;

  @override
  void initState() {
    var body = [];

    for (var i = 0; i < 1000; i++) {
      body.add({
        "type": "ColumnSet",
        "columns": [
          {
            "type": "Column",
            "width": "auto",
            "items": [
              {
                "type": "TextBlock",
                "text": "$i.",
              }
            ]
          },
          {
            "type": "Column",
            "items": [
              {
                "type": "TextBlock",
                "weight": "Bolder",
                "text": "$i aaaaaaaaaaaaaaaaaaaaa",
                "wrap": true,
              },
              {
                "type": "TextBlock",
                "spacing": "None",
                "text": "$i bbbbbbbbbbbbbbbbbbbb",
                "isSubtle": true,
                "wrap": true
              }
            ],
            "width": "stretch"
          }
        ]
      });
    }

    content = {"type": "AdaptiveCard", "body": body};

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Render Time (ListView)"),
        actions: [
          BrightnessSwitch(),
        ],
      ),
      body: Container(
        alignment: Alignment.centerLeft,
        child: AdaptiveCard.memory(
          content: content,
          hostConfigPath: "lib/host_config",
          showDebugJson: false,
          listView: true,
          approximateDarkThemeColors: true,
          supportMarkdown: false,
        ),
      ),
    );
  }
}
