

import 'package:example/loading_adaptive_card.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(new MyApp());
}

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
        title: new Text('Adpative cards lab'),
      ),
      body: new Center(
       child: SingleChildScrollView(child: LabAdaptiveCard(
         payload: '''
{  
                  "type":"AdaptiveCard",
                  "body":[  
                     {  
                        "type":"Container",
                        "items":[  
                           {  
                              "type":"TextBlock",
                              "size":"Medium",
                              "weight":"Bolder",
                              "text":"Open inspections points"
                           }
                        ]
                     },
                     {  
                        "type":"ColumnSet",
                        "separator":true,
                        "spacing":"medium",
                        "columns":[  
                           {  
                              "type":"Column",
                              "width":"auto",
                              "items":[  
                                 {  
                                    "type":"TextBlock",
                                    "text":"Id",
                                    "isSubtle":true,
                                    "weight":"bolder"
                                 },
                                 {  
                                    "type":"TextBlock",
                                    "text":"1",
                                    "spacing":"small"
                                 },
                                 {  
                                    "type":"TextBlock",
                                    "text":"2",
                                    "spacing":"small"
                                 },
                                 {  
                                    "type":"TextBlock",
                                    "text":"3",
                                    "spacing":"small"
                                 },
                                 {  
                                    "type":"TextBlock",
                                    "text":"4",
                                    "spacing":"small"
                                 }
                              ]
                           },
                           {  
                              "type":"Column",
                              "width":"auto",
                              "items":[  
                                 {  
                                    "type":"TextBlock",
                                    "text":"Inspection Point",
                                    "isSubtle":true,
                                    "weight":"bolder"
                                 },
                                 {  
                                    "type":"TextBlock",
                                    "text":"H turbine - Rotor - Seal strips : Loss",
                                    "spacing":"small"
                                 },
                                 {  
                                    "type":"TextBlock",
                                    "text":"H turbine - Rotor - Seal strips : Shear of shroud",
                                    "spacing":"small"
                                 },
                                 {  
                                    "type":"TextBlock",
                                    "text":"Bearing casing MAD11 - Journal bearing - Bearing shell : Damage",
                                    "spacing":"small"
                                 },
                                 {  
                                    "type":"TextBlock",
                                    "text":"Bearing casing MAD11 - Sensors - Thermocouples (bearing) : Damage",
                                    "spacing":"small"
                                 }
                              ]
                           }
                        ]
                     }
                  ],
                  "\$schema":"http://adaptivecards.io/schemas/adaptive-card.json",
                  "version":"1.0"
               }
            
         ''',
       )),
      ),
    );
  }
}

