import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_utils.dart';

Widget getSampleForGoldenTest(Key key, String sampleName) {
  var sample = getWidthDefaultHostConfig(sampleName);

  return MaterialApp(
    home: RepaintBoundary(
      key: key,
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: sample,
        ),
      ),
    ),
  );
}

void main() {
  // Deliver actual images
  setUp(() async {
    HttpOverrides.global = MyTestHttpOverrides();
    WidgetsBinding.instance!.renderView.configuration =
        TestViewConfiguration(size: const Size(500, 700));

    final fontData = File('assets/fonts/Roboto/Roboto-Regular.ttf')
        .readAsBytes()
        .then((bytes) => ByteData.view(Uint8List.fromList(bytes).buffer));
    final fontData2 = File('assets/fonts/Roboto/Roboto-Bold.ttf')
        .readAsBytes()
        .then((bytes) => ByteData.view(Uint8List.fromList(bytes).buffer));
    final fontData3 = File('assets/fonts/Roboto/Roboto-Light.ttf')
        .readAsBytes()
        .then((bytes) => ByteData.view(Uint8List.fromList(bytes).buffer));
    final fontData4 = File('assets/fonts/Roboto/Roboto-Medium.ttf')
        .readAsBytes()
        .then((bytes) => ByteData.view(Uint8List.fromList(bytes).buffer));
    final fontData5 = File('assets/fonts/Roboto/Roboto-Thin.ttf')
        .readAsBytes()
        .then((bytes) => ByteData.view(Uint8List.fromList(bytes).buffer));
    final fontLoader = FontLoader('Roboto')
      ..addFont(fontData)
      ..addFont(fontData2)
      ..addFont(fontData3)
      ..addFont(fontData4)
      ..addFont(fontData5);
    await fontLoader.load();
  });

  testWidgets('Golden Sample 1', (tester) async {
    final binding = tester.binding as AutomatedTestWidgetsFlutterBinding;
    binding.addTime(Duration(seconds: 4));

    var key = ValueKey('paint');
    var sample1 = getSampleForGoldenTest(key, 'example1');

    //await tester.pumpWidget(SizedBox(width:100,height:100,child:
    // Center(child: RepaintBoundary(child: SizedBox(width:500, height: 1200,
    // child: sample1), key: key,))));
    await tester.pumpWidget(sample1);
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(key),
      matchesGoldenFile('gold_files/sample1-base.png'),
    );

    expect(find.widgetWithText(ElevatedButton, 'Set due date'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Set due date'));
    await tester.pump();

    await expectLater(
      find.byKey(key),
      matchesGoldenFile('gold_files/sample1_set_due_date.png'),
    );

    expect(find.widgetWithText(ElevatedButton, "OK"), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, "Comment"));
    await tester.pump();

    await expectLater(
      find.byKey(key),
      matchesGoldenFile('gold_files/sample1_comment.png'),
    );
  });
  testWidgets('Golden Sample 2', (tester) async {
    final binding = tester.binding as AutomatedTestWidgetsFlutterBinding;
    binding.addTime(Duration(seconds: 4));

    var key = ValueKey('paint');
    var sample1 = getSampleForGoldenTest(key, 'example2');

    //await tester.pumpWidget(SizedBox(width:100,height:100,child:
    // Center(child: RepaintBoundary(child: SizedBox(width:500, height: 1200,
    // child: sample1), key: key,))));
    await tester.pumpWidget(sample1);
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(key),
      matchesGoldenFile('gold_files/sample2-base.png'),
    );

    expect(find.widgetWithText(ElevatedButton, "I'll be late"), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, "I'll be late"));
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(key),
      matchesGoldenFile('gold_files/sample2_ill_be_late.png'),
    );

    expect(find.widgetWithText(ElevatedButton, 'Snooze'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Snooze'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(key),
      matchesGoldenFile('gold_files/sample2_snooze.png'),
    );
  });

  testWidgets('Golden Sample 3', (tester) async {
    final binding = tester.binding as AutomatedTestWidgetsFlutterBinding;
    binding.addTime(Duration(seconds: 4));

    var key = ValueKey('paint');
    var sample1 = getSampleForGoldenTest(key, 'example3');

    await tester.pumpWidget(sample1);
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(key),
      matchesGoldenFile('gold_files/sample3-base.png'),
    );
  });

  testWidgets('Golden Sample 4', (tester) async {
    final binding = tester.binding as AutomatedTestWidgetsFlutterBinding;
    binding.addTime(Duration(seconds: 4));

    var key = ValueKey('paint');
    var sample1 = getSampleForGoldenTest(key, 'example4');

    await tester.pumpWidget(sample1);
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(key),
      matchesGoldenFile('gold_files/sample4-base.png'),
    );
  });

  testWidgets('Golden Sample 5', (tester) async {
    final binding = tester.binding as AutomatedTestWidgetsFlutterBinding;
    binding.addTime(Duration(seconds: 4));

    var key = ValueKey('paint');
    var sample1 = getSampleForGoldenTest(key, 'example5');

    await tester.pumpWidget(sample1);
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(key),
      matchesGoldenFile('gold_files/sample5-base.png'),
    );

    expect(find.widgetWithText(ElevatedButton, "Steak"), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Chicken"), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Tofu"), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Steak'));
    await tester.pump();

    await expectLater(
      find.byKey(key),
      matchesGoldenFile('gold_files/sample5-steak.png'),
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Chicken'));
    await tester.pump();

    await expectLater(
      find.byKey(key),
      matchesGoldenFile('gold_files/sample5-chicken.png'),
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Tofu'));
    await tester.pump();

    await expectLater(
      find.byKey(key),
      matchesGoldenFile('gold_files/sample5-tofu.png'),
    );

    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
  // TODO add other tests
  testWidgets('Golden Sample 14', (tester) async {
    final binding = tester.binding as AutomatedTestWidgetsFlutterBinding;
    binding.addTime(Duration(seconds: 4));

    var key = ValueKey('paint');
    var sample1 = getSampleForGoldenTest(key, 'example14');

    await tester.pumpWidget(sample1);
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(key),
      matchesGoldenFile('gold_files/sample14-base.png'),
    );
  });
}
