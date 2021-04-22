import 'package:flutter/material.dart';
import 'package:flutter_adaptive_cards/flutter_adaptive_cards.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Demo Home Page'),
      ),
      body: new Center(
        child: AdaptiveCard.asset(
          assetPath: "sample",
          hostConfigPath: "host_config",
          // TODO fix this
          /*cardRegistry: CardRegistry(addedActions: {
            "Action.Submit": (map, widgetState, card) =>
                AdaptiveActionSubmit(map, widgetState, color: Colors.red)
          }),*/
        ),
      ),
    );
  }
}
