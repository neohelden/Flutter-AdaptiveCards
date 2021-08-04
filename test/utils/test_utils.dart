import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_adaptive_cards/flutter_adaptive_cards.dart';

class MyTestHttpOverrides extends HttpOverrides {}

Widget getWidthDefaultHostConfig(String name) {
  return getWidget(name, 'host_config.json');
}

Map? getDefaultHostConfig() {
  var hostConfigFile = File('host_configs/host_config.json');
  var config = hostConfigFile.readAsStringSync();
  return json.decode(config);
}

Widget getWidget(String path, String hostConfigPath) {
  var file = File('test/samples/$path.json');
  var hostConfigFile = File('test/host_configs/$hostConfigPath');
  var map = json.decode(file.readAsStringSync());
  var hostConfig = json.decode(hostConfigFile.readAsStringSync());
  Widget adaptiveCard = RawAdaptiveCard.fromMap(
    map,
    hostConfig,
    onSubmit: (_) {},
    onOpenUrl: (_) {},
    listView: false,
  );

  return MaterialApp(
    home: adaptiveCard,
  );
}
