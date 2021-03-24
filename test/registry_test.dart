import 'package:flutter/material.dart';
import 'package:flutter_adaptive_cards/flutter_adaptive_cards.dart';
import 'package:flutter_adaptive_cards/src/elements/media.dart';
import 'package:flutter_adaptive_cards/src/elements/text_block.dart';
import 'package:flutter_adaptive_cards/src/elements/unknown.dart';
import 'package:flutter_adaptive_cards/src/registry.dart';
import 'package:flutter_adaptive_cards/src/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAdaptiveCardState extends Mock implements RawAdaptiveCardState {

  @override
  UUIDGenerator get idGenerator => UUIDGenerator();

  @override
  String toString({DiagnosticLevel minLevel =  DiagnosticLevel.info}) {
    return "";
  }
}

void main() {
  RawAdaptiveCardState state;
  setUp(() {
    state = MockAdaptiveCardState();
  });

  testWidgets('Basic types return', (tester) async {
    CardRegistry cardRegistry = CardRegistry();
    Widget adaptiveElement = cardRegistry.getElement({
      "type": "TextBlock",
      "text": "Adaptive Card design session",
      "size": "large",
      "weight": "bolder"
    });

    expect(adaptiveElement.runtimeType, equals(AdaptiveTextBlock));

    Widget second = cardRegistry.getElement({
      "type": "Media",
      "poster":
          "https://docs.microsoft.com/en-us/adaptive-cards/content/videoposter.png",
      "sources": [
        {
          "mimeType": "video/mp4",
          "url":
              "https://adaptivecardsblob.blob.core.windows.net/assets/AdaptiveCardsOverviewVideo.mp4"
        }
      ]
    });

    expect(second.runtimeType, equals(AdaptiveMedia));
  });

  testWidgets('Unknown element', (tester) async {
    CardRegistry cardRegistry = CardRegistry();

    Widget adaptiveElement = cardRegistry.getElement({'type': "NoType"});

    expect(adaptiveElement.runtimeType, equals(AdaptiveUnknown));

    AdaptiveUnknown unknown = adaptiveElement as AdaptiveUnknown;

    expect(unknown.type, equals('NoType'));
  });

  testWidgets('Removed element', (tester) async {
    CardRegistry cardRegistry = CardRegistry(removedElements: ['TextBlock']);

    Widget adaptiveElement = cardRegistry.getElement({
      "type": "TextBlock",
      "text": "Adaptive Card design session",
      "size": "large",
      "weight": "bolder"
    });

    expect(adaptiveElement.runtimeType, equals(AdaptiveUnknown));

    AdaptiveUnknown unknown = adaptiveElement as AdaptiveUnknown;

    expect(unknown.type, equals('TextBlock'));
  });

  testWidgets('Add element', (tester) async {
    CardRegistry cardRegistry =
        CardRegistry(addedElements: {'Test': (map) => _TestAddition()});

    var element = cardRegistry.getElement({'type': "Test"});

    expect(element.runtimeType, equals(_TestAddition));

    await tester.pumpWidget(element);

    expect(find.text('Test'), findsOneWidget);
  });
}

class _TestAddition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        child: Text('Test'),
      ),
    );
  }
}
