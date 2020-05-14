import 'package:example/loading_adaptive_card.dart';
import 'package:flutter/material.dart';

class ActionSetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ActionSet"),
      ),
      body: ListView(
        children: <Widget>[
          DemoAdaptiveCard(
            "lib/action_set/example1",
          ),
        ],
      ),
    );
  }
}
