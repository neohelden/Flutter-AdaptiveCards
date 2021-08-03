import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_adaptive_cards/flutter_adaptive_cards.dart';

/// A AdaptiveCard with the option to see its json.
class DemoAdaptiveCard extends StatefulWidget {
  /// Creates a DemoAdaptiveCard.
  const DemoAdaptiveCard(
    this.assetPath, {
    Key? key,
    this.hostConfig,
    this.supportMarkdown = true,
  }) : super(key: key);

  /// The path to the card content.
  final String assetPath;

  /// The host config.
  final String? hostConfig;

  /// Whether markdown is rendered.
  final bool supportMarkdown;

  @override
  _DemoAdaptiveCardState createState() => _DemoAdaptiveCardState();
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
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child:   AdaptiveCard.asset(
                  assetPath: widget.assetPath,
                  listView: false,
                  hostConfigPath:
                  isLight ? "lib/host_config_light.json" : "lib/host_config_dark.json",
                  showDebugJson: false,
                  hostConfig: widget.hostConfig,
                  supportMarkdown: false,
                ),
              ),
            ),
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
