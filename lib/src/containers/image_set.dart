import 'package:flutter/material.dart';

import '../additional.dart';
import '../base.dart';
import '../elements/image.dart';
import '../utils.dart';

/// Displays a set of images.
class AdaptiveImageSet extends StatefulWidget with AdaptiveElementWidgetMixin {

  /// Creates a AdaptiveImageSet widget.
  AdaptiveImageSet({
    Key? key,
    required this.adaptiveMap,
    required this.supportMarkdown,
  }) : super(key: key);

  final Map adaptiveMap;

  /// Whether markdown is rendered.
  final bool supportMarkdown;

  @override
  _AdaptiveImageSetState createState() => _AdaptiveImageSetState();
}

class _AdaptiveImageSetState extends State<AdaptiveImageSet>
    with AdaptiveElementMixin {
  late List<AdaptiveImage> images;

  String? imageSize;
  double? maybeSize;

  @override
  void initState() {
    super.initState();

    images = List<Map>.from(adaptiveMap["images"])
        .map((child) => AdaptiveImage(
              adaptiveMap: child,
              supportMarkdown: widget.supportMarkdown,
            ))
        .toList();

    loadSize();
  }

  @override
  Widget build(BuildContext context) {
    var backgroundColor =
        getBackgroundColorIfNoBackgroundImageAndNoDefaultStyle(
      resolver: resolver,
      adaptiveMap: adaptiveMap,
      brightness: Theme.of(context).brightness,
    );

    return SeparatorElement(
      adaptiveMap: adaptiveMap,
      child: Container(
        color: backgroundColor,
        child: LayoutBuilder(builder: (context, constraints) {
          return Wrap(
            //maxCrossAxisExtent: 200.0,
            children: images
                .map((img) => SizedBox(
                      width: calculateSize(constraints),
                      child: img,
                    ))
                .toList(),
            //shrinkWrap: true,
          );
        }),
      ),
    );
  }

  double? calculateSize(BoxConstraints constraints) {
    if (maybeSize != null) return maybeSize;
    if (imageSize == "stretch") return constraints.maxWidth;
    // Display a maximum of 5 children
    if (images.length >= 5) {
      return constraints.maxWidth / 5;
    } else if (images.isEmpty) {
      return 0.0;
    } else {
      return constraints.maxWidth / images.length;
    }
  }

  void loadSize() {
    String sizeDescription = adaptiveMap["imageSize"] ?? "auto";
    if (sizeDescription == "auto") {
      imageSize = "auto";
      return;
    }
    if (sizeDescription == "stretch") {
      imageSize = "stretch";
      return;
    }
    int size = resolver!.resolve("imageSizes", sizeDescription);
    maybeSize = size.toDouble();
  }
}
