import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:example/action_set/action_set_page.dart';
import 'package:example/render_time/render_time_page.dart';
import 'package:example/samples/samples.dart';
import 'package:example/text_block/text_block_examples_page.dart';
import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';

import 'about_page.dart';
import 'action_open_url/action_open_url_examples_page.dart';
import 'action_show_card/action_show_card_examples_page.dart';
import 'action_submit/action_submit_examples_page.dart';
import 'brightness_switch.dart';
import 'column/column_examples_page.dart';
import 'column_set/column_set_examples_page.dart';
import 'container/container_examples_page.dart';
import 'fact_set/fact_set_examples_page.dart';
import 'image/image_examples_page.dart';
import 'image_set/image_set_examples_page.dart';
import 'inputs/input_choice_set/input_choice_set.dart';
import 'inputs/input_date/input_date.dart';
import 'inputs/input_number/input_number.dart';
import 'inputs/input_text/input_text.dart';
import 'inputs/input_time/input_time.dart';
import 'inputs/input_toggle/input_toggle.dart';
import 'media/media.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      initial: AdaptiveThemeMode.dark,
      light: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      dark: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      builder: (context, theme) {
        return MaterialApp(
          title: 'Flutter Adaptive Cards',
          theme: theme,
          home: MyHomePage(),
          routes: {
            "Samples": (context) => SamplesPage(),
            "TextBlock": (context) => TextBlockPage(),
            "Image": (context) => ImagePage(),
            "Container": (context) => ContainerPage(),
            "ColumnSet": (context) => ColumnSetPage(),
            "Column": (context) => ColumnPage(),
            "FactSet": (context) => FactSetPage(),
            "ImageSet": (context) => ImageSetPage(),
            "ActionSet": (context) => ActionSetPage(),
            "Action.OpenUrl": (context) => ActionOpenUrlPage(),
            "Action.Submit": (context) => ActionSubmitPage(),
            "Action.ShowCard": (context) => ActionShowCardPage(),
            "Input.Text": (context) => InputText(),
            "Input.Number": (context) => InputNumber(),
            "Media": (context) => MediaPage(),
            "Input.Date": (context) => InputDatePage(),
            "Input.Time": (context) => InputTimePage(),
            "Input.Toggle": (context) => InputTogglePage(),
            "Input.ChoiceSet": (context) => InputChoiceSetPage(),
            "about": (context) => AboutPage(),
            "Render Time": (context) => RenderTimePage()
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Adaptive Cards"),
        actions: [
          BrightnessSwitch(),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pushNamed("about");
            },
            child: Text(
              "About",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/banner.jpg",
                  ),
                  Divider(),
                  Text(
                    "Flutter-Adaptive Cards by Neohelden",
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          getButton("Samples"),
          getRow(["Image", "ImageSet"]),
          getButton("Media"),
          Divider(),
          getRow(["Action.OpenUrl", "Action.Submit", "Action.ShowCard"]),
          getButton("ActionSet"),
          Divider(),
          getButton("Container"),
          getButton("FactSet"),
          getButton("TextBlock"),
          getRow(["Column", "ColumnSet"]),
          Divider(),
          getRow(["Input.Text", "Input.Number", "Input.Date"]),
          getRow(["Input.Time", "Input.Toggle", "Input.ChoiceSet"]),
          Divider(),
          getButton("Render Time"),
        ],
      ),
    );
  }

  Widget getRow(List<String> element) {
    return Row(
      children: element
          .map(
            (it) => Expanded(child: getButton(it)),
          )
          .toList(),
    );
  }

  Widget getButton(String element) {
    return Card(
      child: InkWell(
          onTap: () => pushNamed(element),
          child: SizedBox(
            height: 64.0,
            child: Center(child: Text(element)),
          )),
    );
  }

  void pushNamed(String element) {
    Navigator.pushNamed(context, element);
  }
}
