import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_adaptive_cards/flutter_adaptive_cards.dart';

class LabAdaptiveCard extends StatelessWidget {
  const LabAdaptiveCard({Key? key, required this.payload}) : super(key: key);

  final String payload;

  @override
  Widget build(BuildContext context) {
    return AdaptiveCard.memory(
      hostConfigPath: "lib/host_config",
      content: json.decode(payload),
      showDebugJson: true,
    );
  }
}

class DemoAdaptiveCard extends StatefulWidget {
  const DemoAdaptiveCard(
    this.assetPath, {
    Key? key,
    this.hostConfig,
    this.approximateDarkThemeColors = true,
    this.supportMarkdown = true,
  }) : super(key: key);

  final String assetPath;
  final String? hostConfig;
  final bool approximateDarkThemeColors;
  final bool supportMarkdown;

  @override
  _DemoAdaptiveCardState createState() => new _DemoAdaptiveCardState();
}

class _DemoAdaptiveCardState extends State<DemoAdaptiveCard>
    with AutomaticKeepAliveClientMixin {
  late String jsonFile;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString(widget.assetPath).then((string) {
      jsonFile = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var isLight = Theme.of(context).brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          AdaptiveCard.asset(
            assetPath: widget.assetPath,
            hostConfigPath:
                isLight ? "lib/host_config_light" : "lib/host_config_dark",
            showDebugJson: false,
            hostConfig: widget.hostConfig,
            approximateDarkThemeColors: widget.approximateDarkThemeColors,
            supportMarkdown: widget.supportMarkdown,
          ),
          TextButton(
            style: TextButton.styleFrom(primary: Colors.indigo),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("JSON"),
                      content: SingleChildScrollView(child: Text(jsonFile)),
                      actions: <Widget>[
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Thanks"),
                          ),
                        )
                      ],
                      contentPadding: EdgeInsets.all(8.0),
                    );
                  });
            },
            child: Text("Show the JSON"),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
