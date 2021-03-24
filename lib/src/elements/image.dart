import 'package:flutter/material.dart';
import 'package:flutter_adaptive_cards/src/additional.dart';
import 'package:flutter_adaptive_cards/src/base.dart';
import 'package:flutter_adaptive_cards/src/utils.dart';

class AdaptiveImage extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveImage({Key? key, required this.adaptiveMap, this.parentMode = "stretch", required this.supportMarkdown}) : super(key: key);

  final Map adaptiveMap;
  final String parentMode;
  final bool supportMarkdown;

  @override
  _AdaptiveImageState createState() => _AdaptiveImageState();
}

class _AdaptiveImageState extends State<AdaptiveImage> with AdaptiveElementMixin {
  late Alignment horizontalAlignment;
  late bool isPerson;
  double? width;
  double? height;

  @override
  void initState() {
    super.initState();
    horizontalAlignment = loadAlignment();
    isPerson = loadIsPerson();
    loadSize();
  }

  @override
  Widget build(BuildContext context) {
    //TODO alt text

    BoxFit fit = BoxFit.contain;
    if (height != null && width != null) {
      fit = BoxFit.fill;
    }

    Widget image = AdaptiveTappable(
      adaptiveMap: adaptiveMap,
      child: Image(
        image: NetworkImage(url!),
        fit: fit,
        width: width,
        height: height,
      ),
    );

    if (isPerson) {
      image = ClipOval(
        clipper: FullCircleClipper(),
        child: image,
      );
    }

    Widget child;

    if (widget.supportMarkdown) {
      child = Align(
        alignment: horizontalAlignment,
        child: image,
      );
    } else {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          (widget.parentMode == "auto")
              ? Flexible(child: image)
              : Expanded(child: Align(alignment: horizontalAlignment, child: image))
        ],
      );
    }

    return SeparatorElement(
      adaptiveMap: adaptiveMap,
      child: child,
    );
  }

  Alignment loadAlignment() {
    String alignmentString = adaptiveMap["horizontalAlignment"]?.toLowerCase() ?? "left";
    switch (alignmentString) {
      case "left":
        return Alignment.centerLeft;
      case "center":
        return Alignment.center;
      case "right":
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }

  bool loadIsPerson() {
    if (adaptiveMap["style"] == null || adaptiveMap["style"] == "default") return false;
    return true;
  }

  String? get url => adaptiveMap["url"];

  void loadSize() {
    String sizeDescription = adaptiveMap["size"] ?? "auto";
    sizeDescription = sizeDescription.toLowerCase();

    int? size;
    if (sizeDescription != "auto" && sizeDescription != "stretch") {
      size = resolver!.resolve("imageSizes", sizeDescription);
    }

    var width = size;
    var height = size;

    // Overwrite dynamic size if fixed size is given
    if (adaptiveMap["width"] != null) {
      var widthString = adaptiveMap["width"].toString();
      widthString = widthString.substring(0, widthString.length - 2); // remove px
      width = int.parse(widthString);
    }
    if (adaptiveMap["height"] != null) {
      var heightString = adaptiveMap["height"].toString();
      heightString = heightString.substring(0, heightString.length - 2); // remove px
      height = int.parse(heightString);
    }

    if (height == null && width == null) {
      return null;
    }

    this.width = width?.toDouble();
    this.height = height?.toDouble();
  }
}
