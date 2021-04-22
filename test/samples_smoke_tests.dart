import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'utils/test_utils.dart';

void main() {
  // Deliver actual images
  setUp(() {
    HttpOverrides.global = MyTestHttpOverrides();
  });


  for(int i = 1; i <= 15; i++) {
    testWidgets('sample$i smoke test', (tester) async {
      final binding = tester.binding as AutomatedTestWidgetsFlutterBinding;
      binding.addTime(Duration(seconds: 10));
      Widget widget = getWidget('example$i', 'host_config');

      // 8 is pretty big, we need to wrap in in a scrollable
      // and 15 is resizing.
      if(i == 8 || i == 15) {
        widget = SingleChildScrollView(
          child: IntrinsicHeight(child: widget),
        );
      }
      await tester.pumpWidget(widget);
    });
  }
}