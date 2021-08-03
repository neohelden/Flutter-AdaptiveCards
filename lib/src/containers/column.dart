import 'package:flutter/material.dart';
import 'package:flutter_adaptive_cards/src/elements/image/cross_network_image.dart';

import '../additional.dart';
import '../base.dart';
import '../utils.dart';

/// Displays multiple AdaptiveElements in a column.
class AdaptiveColumn extends StatefulWidget with AdaptiveElementWidgetMixin {

  /// Creates an AdaptiveColumn widget.
  AdaptiveColumn({
    Key? key,
    required this.adaptiveMap,
    required this.supportMarkdown,
  }) : super(key: key);

  final Map adaptiveMap;

  /// Whether markdown is supported.
  final bool supportMarkdown;

  @override
  _AdaptiveColumnState createState() => _AdaptiveColumnState();
}

class _AdaptiveColumnState extends State<AdaptiveColumn>
    with AdaptiveElementMixin {

  late List<Widget> items;

  /// Can be "auto", "stretch" or "weighted"
  late String mode;
  late int width;

  late MainAxisAlignment verticalAlignment;
  late CrossAxisAlignment horizontalAlignment;
  Alignment? containerHorizontalAlignment;

  GenericAction? action;

  // Need to do the separator manually for this class
  // because the flexible needs to be applied to the class above
  late double precedingSpacing;
  Widget? backgroundImage;
  bool? separator;

  @override
  void initState() {
    super.initState();

    if (adaptiveMap.containsKey("selectAction")) {
      action = widgetState!.cardRegistry.getGenericAction(
        adaptiveMap["selectAction"],
        widgetState,
      );
    }
    precedingSpacing = resolver!.resolveSpacing(adaptiveMap["spacing"]);
    separator = adaptiveMap["separator"] ?? false;

    backgroundImage = _getBackgroundImage(adaptiveMap);

    var toParseWidth = adaptiveMap["width"];
    if (toParseWidth != null) {
      if (toParseWidth == "auto") {
        mode = "auto";
      } else if (toParseWidth == "stretch") {
        mode = "stretch";
      } else if (toParseWidth is int) {
        width = toParseWidth;
        mode = "weighted";
      } else {
        var widthString = toParseWidth.toString();

        if (widthString.endsWith("px")) {
          widthString = widthString.substring(
            0,
            widthString.length - 2,
          ); // remove px
          width = int.parse(widthString);
          mode = "px";
        } else {
          // Handle gracefully
          mode = "auto";
        }
      }
    } else {
      mode = "auto";
    }

    if (adaptiveMap["items"] != null) {
      items = List<Map>.from(adaptiveMap["items"]).map((child) {
        return widgetState!.cardRegistry.getElement(
          child as Map<String, dynamic>,
          parentMode: mode,
        );
      }).toList();
    } else {
      items = [];
    }

    verticalAlignment = loadVerticalAlignment();
    horizontalAlignment = loadHorizontalAlignment();
    containerHorizontalAlignment = loadHorizontalContainerAlignment();
  }

  MainAxisAlignment loadVerticalAlignment() {
    String verticalAlignment =
        adaptiveMap["verticalContentAlignment"]?.toLowerCase() ?? "top";

    switch (verticalAlignment) {
      case "top":
        return MainAxisAlignment.start;
      case "center":
        return MainAxisAlignment.center;
      case "bottom":
        return MainAxisAlignment.end;
      default:
        return MainAxisAlignment.start;
    }
  }

  CrossAxisAlignment loadHorizontalAlignment() {
    String horizontalAlignment =
        adaptiveMap["horizontalAlignment"]?.toLowerCase() ?? "left";

    switch (horizontalAlignment) {
      case "left":
        return CrossAxisAlignment.start;
      case "center":
        return CrossAxisAlignment.center;
      case "right":
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.start;
    }
  }

  Alignment? loadHorizontalContainerAlignment() {
    String? horizontalAlignment =
        adaptiveMap["horizontalAlignment"]?.toLowerCase();

    switch (horizontalAlignment) {
      case "left":
        return Alignment.topLeft;
      case "center":
        return Alignment.topCenter;
      case "right":
        return Alignment.topRight;
      default:
        return null;
    }
  }

  Widget _getBackgroundImage(Map? element) {
    var backgroundImage = adaptiveMap["backgroundImage"];
    if (backgroundImage != null) {
      var backgroundImageUrl = backgroundImage["url"];
      var fillMode = backgroundImage["fillMode"];

      BoxFit fit;
      switch (fillMode) {
        case "RepeatVertically":
        case "RepeatHorizontally":
        case "Repeat":
          fit = BoxFit.none;
          break;
        default:
          fit = BoxFit.cover;
      }

      ImageRepeat repeat;
      switch (fillMode) {
        case "RepeatVertically":
          repeat = ImageRepeat.repeatY;
          break;
        case "RepeatHorizontally":
          repeat = ImageRepeat.repeatX;
          break;
        case "Repeat":
          repeat = ImageRepeat.repeat;
          break;
        default:
          repeat = ImageRepeat.noRepeat;
      }

      if (backgroundImageUrl != null) {
        return CrossNetworkImage(
          repeat: repeat,
          url: backgroundImageUrl,
          fit: fit,
        );
      }
    }
    return SizedBox(
      width: 0,
      height: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    var backgroundColor =
        getBackgroundColorIfNoBackgroundImageAndNoDefaultStyle(
      resolver: resolver,
      adaptiveMap: adaptiveMap,
      brightness: Theme.of(context).brightness,
    );

    Widget child = Container(
      alignment: containerHorizontalAlignment,
      color: backgroundColor,
      child: Column(
        children: []..addAll(items.map((it) => it).toList()),
        crossAxisAlignment: horizontalAlignment,
        mainAxisAlignment: verticalAlignment,
      ),
    );

    if (!widget.supportMarkdown) {
      child = Expanded(child: child);
    }

    Widget result = Stack(
      children: [
        backgroundImage!,
        InkWell(
          onTap: action?.tap,
          child: Padding(
            padding: EdgeInsets.only(left: precedingSpacing),
            child: SeparatorElement(
              adaptiveMap: adaptiveMap,
              child: child,
            ),
          ),
        ),
      ],
    );

    assert(mode == "auto" ||
        mode == "stretch" ||
        mode == "weighted" ||
        mode == "px");
    if (mode == "auto") {
      return Flexible(child: result);
    } else if (mode == "stretch") {
      return Expanded(
        child: result,
      );
    } else if (mode == "weighted") {
      return Expanded(
        flex: width,
        child: result,
      );
    } else if (mode == "px") {
      return Container(
        width: width.toDouble(),
        child: result,
      );
    }

    return ChildStyler(adaptiveMap: adaptiveMap, child: result);
  }
}
