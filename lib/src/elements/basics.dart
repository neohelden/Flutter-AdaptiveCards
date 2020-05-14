import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_cards/flutter_adaptive_cards.dart';
import 'package:flutter_adaptive_cards/src/elements/actions.dart';
import 'package:flutter_adaptive_cards/src/elements/additional.dart';
import 'package:flutter_adaptive_cards/src/elements/base.dart';
import 'package:flutter_adaptive_cards/src/utils.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class AdaptiveCardElement extends StatefulWidget
    with AdaptiveElementWidgetMixin {
  AdaptiveCardElement({Key key, this.adaptiveMap}) : super(key: UniqueKey());

  final Map adaptiveMap;

  @override
  AdaptiveCardElementState createState() => AdaptiveCardElementState();
}

class AdaptiveCardElementState extends State<AdaptiveCardElement>
    with AdaptiveElementMixin {
  String currentCardId;

  List<Widget> children;

  List<Widget> allActions = [];

  List<AdaptiveActionShowCard> showCardActions = [];
  List<Widget> cards = [];

  Axis actionsOrientation;

  String backgroundImage;

  Map<String, Widget> _registeredCards = Map();

  void registerCard(String id, Widget it) {
    _registeredCards[id] = it;
  }

  static AdaptiveCardElementState of(BuildContext context) {
    return Provider.of<AdaptiveCardElementState>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();

    String stringAxis = resolver.resolve("actions", "actionsOrientation");
    if (stringAxis == "Horizontal") {
      actionsOrientation = Axis.horizontal;
    } else if (stringAxis == "Vertical") {
      actionsOrientation = Axis.vertical;
    }
    children = List<Map>.from(adaptiveMap["body"])
        .map((map) => widgetState.cardRegistry.getElement(map))
        .toList();

    backgroundImage = adaptiveMap['backgroundImage'];
  }

  void loadChildren() {
    if (widget.adaptiveMap.containsKey("actions")) {
      allActions = List<Map>.from(widget.adaptiveMap["actions"])
          .map((adaptiveMap) => widgetState.cardRegistry.getAction(adaptiveMap))
          .toList();

      showCardActions = List<AdaptiveActionShowCard>.from(allActions
          .where((action) => action is AdaptiveActionShowCard)
          .toList());

      cards = List<Widget>.from(showCardActions
          .map((action) =>
              widgetState.cardRegistry.getElement(action.adaptiveMap["card"]))
          .toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    loadChildren();

    List<Widget> widgetChildren = children.map((element) => element).toList();

    // Adds the actions
    List<Widget> actionWidgets = allActions
        .map((action) => Padding(
              padding: EdgeInsets.only(right: 8),
              child: action,
            ))
        .toList();

    Widget actionWidget;
    if (actionsOrientation == Axis.vertical) {
      actionWidget = Column(
        children: actionWidgets,
        mainAxisAlignment: MainAxisAlignment.start,
      );
    } else {
      actionWidget = Row(
        children: actionWidgets,
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    }
    widgetChildren.add(actionWidget);

    if (currentCardId != null) {
      widgetChildren.add(_registeredCards[currentCardId]);
    }
    Widget result = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: widgetChildren,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );

    if (backgroundImage != null) {
      result = Stack(
        children: <Widget>[
          Positioned.fill(
              child: Image.network(
            backgroundImage,
            fit: BoxFit.cover,
          )),
          result,
        ],
      );
    }

    return Provider<AdaptiveCardElementState>.value(
      value: this,
      child: result,
    );
  }

  /// This is called when an [_AdaptiveActionShowCard] triggers it.
  void showCard(String id) {
    if (currentCardId == id) {
      currentCardId = null;
    } else {
      currentCardId = id;
    }
    setState(() {});
  }
}

class AdaptiveTextBlock extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveTextBlock({Key key, this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveTextBlockState createState() => _AdaptiveTextBlockState();
}

class _AdaptiveTextBlockState extends State<AdaptiveTextBlock>
    with AdaptiveElementMixin {
  FontWeight fontWeight;
  double fontSize;
  Alignment horizontalAlignment;
  int maxLines;
  String text;

  @override
  void initState() {
    super.initState();
    fontSize = resolver.resolveFontSize(adaptiveMap["size"]);
    fontWeight = resolver.resolveFontWeight(adaptiveMap["weight"]);
    horizontalAlignment = loadAlignment();
    maxLines = loadMaxLines();

    text = parseTextString(adaptiveMap['text']);
  }

  /*child: Text(
            text,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
              color: getColor(Theme.of(context).brightness),
            ),
            maxLines: maxLines,
          )*/

  // TODO create own widget that parses _basic_ markdown.
  // This might help: https://docs.flutter.io/flutter/widgets/Wrap-class.html
  @override
  Widget build(BuildContext context) {
    return SeparatorElement(
      adaptiveMap: adaptiveMap,
      child: Align(
        // TODO IntrinsicWidth finxed a few things, but breaks more
        alignment: horizontalAlignment,
        child: MarkdownBody(
          // TODO the markdown library does currently not support max lines
          // As markdown support is more important than maxLines right now
          // this is in here.
          //maxLines: maxLines,
          data: text,
          styleSheet: loadMarkdownStyleSheet(),
          onTapLink: (href) {
            RawAdaptiveCardState.of(context).openUrl(href);
          },
        ),
      ),
    );
  }

  /*String textCappedWithMaxLines() {
    if(text.split("\n").length <= maxLines) return text;
    return text.split("\n").take(maxLines).reduce((o,t) => "$o\n$t") + "...";
  }*/

  // Probably want to pass context down the tree, until now -> this
  Color getColor(Brightness brightness) {
    Color color =
        resolver.resolveColor(adaptiveMap["color"], adaptiveMap["isSubtle"]);
    if (!widgetState.widget.approximateDarkThemeColors) return color;
    return adjustColorToFitDarkTheme(color, brightness);
  }

  Alignment loadAlignment() {
    String alignmentString =
        widget.adaptiveMap["horizontalAlignment"] ?? "left";

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

  /// This also takes care of the wrap property, because maxLines = 1 => no wrap
  int loadMaxLines() {
    bool wrap = widget.adaptiveMap["wrap"] ?? false;
    if (!wrap) return 1;
    // can be null, but that's okay for the text widget.
    return widget.adaptiveMap["maxLines"];
  }

  /// TODO Markdown still has some problems
  MarkdownStyleSheet loadMarkdownStyleSheet() {
    TextStyle style = TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: getColor(
          Theme.of(context).brightness,
        ));

    return MarkdownStyleSheet(
      a: style,
      blockquote: style,
      code: style,
      em: style,
      strong: style.copyWith(fontWeight: FontWeight.bold),
      p: style,
    );
  }
}

class AdaptiveContainer extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveContainer({Key key, this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveContainerState createState() => _AdaptiveContainerState();
}

class _AdaptiveContainerState extends State<AdaptiveContainer>
    with AdaptiveElementMixin {
// TODO implement verticalContentAlignment
  List<Widget> children;

  Color backgroundColor;

  @override
  void initState() {
    super.initState();
    if (adaptiveMap["items"] != null) {
      children = List<Map>.from(adaptiveMap["items"]).map((child) {
        return widgetState.cardRegistry.getElement(child);
      }).toList();
    } else {
      children = [];
    }

    String colorString = resolver.hostConfig["containerStyles"]
        [adaptiveMap["style"] ?? "default"]["backgroundColor"];

    backgroundColor = parseColor(colorString);
  }

  @override
  Widget build(BuildContext context) {
    return ChildStyler(
      adaptiveMap: adaptiveMap,
      child: AdaptiveTappable(
        adaptiveMap: adaptiveMap,
        child: SeparatorElement(
          adaptiveMap: adaptiveMap,
          child: Container(
            color: Theme.of(context).brightness == Brightness.dark &&
                    adaptiveMap["style"] == null
                ? null
                : backgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: children.toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdaptiveColumnSet extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveColumnSet({Key key, this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveColumnSetState createState() => _AdaptiveColumnSetState();
}

class _AdaptiveColumnSetState extends State<AdaptiveColumnSet>
    with AdaptiveElementMixin {
  List<AdaptiveColumn> columns;

  @override
  void initState() {
    super.initState();
    columns = List<Map>.from(adaptiveMap["columns"] ?? [])
        .map((child) => AdaptiveColumn(adaptiveMap: child))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SeparatorElement(
      adaptiveMap: adaptiveMap,
      child: AdaptiveTappable(
        adaptiveMap: adaptiveMap,
        child: Row(
          children: columns.toList(),
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}

class AdaptiveColumn extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveColumn({Key key, this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveColumnState createState() => _AdaptiveColumnState();
}

class _AdaptiveColumnState extends State<AdaptiveColumn>
    with AdaptiveElementMixin {
  List<Widget> items;

  /// Can be "auto", "stretch" or "manual"
  String mode;
  int width;

  GenericAction action;

  // Need to do the separator manually for this class
  // because the flexible needs to be applied to the class above
  double precedingSpacing;
  bool separator;

  @override
  void initState() {
    super.initState();

    if (adaptiveMap.containsKey("selectAction")) {
      action = widgetState.cardRegistry
          .getGenericAction(adaptiveMap["selectAction"], widgetState);
    }
    precedingSpacing = resolver.resolveSpacing(adaptiveMap["spacing"]);
    separator = adaptiveMap["separator"] ?? false;

    items = adaptiveMap["items"] != null
        ? List<Map>.from(adaptiveMap["items"]).map((child) {
            return widgetState.cardRegistry.getElement(child);
          }).toList()
        : [];

    var toParseWidth = adaptiveMap["width"];
    if (toParseWidth != null) {
      if (toParseWidth == "auto") {
        mode = "auto";
      } else if (toParseWidth == "stretch") {
        mode = "stretch";
      } else if (toParseWidth is int) {
        if (toParseWidth != null) {
          width = toParseWidth;
          mode = "manual";
        } else {
          // Handle gracefully
          mode = "auto";
        }
      } else {
        // Handle gracefully
        mode = "auto";
      }
    } else {
      mode = "auto";
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget result = InkWell(
      onTap: action?.tap,
      child: Padding(
        padding: EdgeInsets.only(left: precedingSpacing),
        child: Column(
          children: []
            ..add(
              separator ? Divider() : SizedBox(),
            )
            ..addAll(items.map((it) => it).toList()),
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );

    assert(mode == "auto" || mode == "stretch" || mode == "manual");
    if (mode == "auto") {
      result = Flexible(child: result);
    } else if (mode == "stretch") {
      result = Expanded(
        child: result,
      );
    } else if (mode == "manual") {
      result = Flexible(
        flex: width,
        child: result,
      );
    }

    return ChildStyler(adaptiveMap: adaptiveMap, child: result);
  }
}

class AdaptiveFactSet extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveFactSet({Key key, this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveFactSetState createState() => _AdaptiveFactSetState();
}

class _AdaptiveFactSetState extends State<AdaptiveFactSet>
    with AdaptiveElementMixin {
  List<Map> facts;

  @override
  void initState() {
    super.initState();
    facts = List<Map>.from(adaptiveMap["facts"]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SeparatorElement(
      adaptiveMap: adaptiveMap,
      child: Row(
        children: [
          Column(
            children: facts
                .map((fact) => Text(
                      fact["title"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
                .toList(),
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          SizedBox(
            width: 8.0,
          ),
          Column(
            children: facts.map((fact) => Text(fact["value"])).toList(),
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}

class AdaptiveImage extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveImage({Key key, this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveImageState createState() => _AdaptiveImageState();
}

class _AdaptiveImageState extends State<AdaptiveImage>
    with AdaptiveElementMixin {
  Alignment horizontalAlignment;
  bool isPerson;
  Tuple<double, double> size;

  @override
  void initState() {
    super.initState();
    horizontalAlignment = loadAlignment();
    isPerson = loadIsPerson();
    size = loadSize();
  }

  @override
  Widget build(BuildContext context) {
    //TODO alt text
    Widget image = Image(
      image: NetworkImage(url),
      fit: BoxFit.contain,
    );

    if (isPerson) {
      image = ClipOval(
        clipper: FullCircleClipper(),
        child: image,
      );
    }

    image = Align(
      alignment: horizontalAlignment,
      child: image,
    );

    if (size != null) {
      image = ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: size.a,
            minHeight: size.a,
            maxHeight: size.b,
            maxWidth: size.b),
        child: image,
      );
    }
    return SeparatorElement(
      adaptiveMap: adaptiveMap,
      child: image,
    );
  }

  Alignment loadAlignment() {
    String alignmentString = adaptiveMap["horizontalAlignment"] ?? "left";
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
    if (adaptiveMap["style"] == null || adaptiveMap["style"] == "default")
      return false;
    return true;
  }

  String get url => adaptiveMap["url"];

  Tuple<double, double> loadSize() {
    String sizeDescription = adaptiveMap["size"] ?? "auto";
    sizeDescription = sizeDescription.toLowerCase();
    if (sizeDescription == "auto" || sizeDescription == "stretch") return null;
    int size = resolver.resolve("imageSizes", sizeDescription);
    return Tuple(size.toDouble(), size.toDouble());
  }
}

class AdaptiveImageSet extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveImageSet({Key key, this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveImageSetState createState() => _AdaptiveImageSetState();
}

class _AdaptiveImageSetState extends State<AdaptiveImageSet>
    with AdaptiveElementMixin {
  List<AdaptiveImage> images;

  String imageSize;
  double maybeSize;

  @override
  void initState() {
    super.initState();

    images = List<Map>.from(adaptiveMap["images"])
        .map((child) => AdaptiveImage(adaptiveMap: child))
        .toList();

    loadSize();
  }

  @override
  Widget build(BuildContext context) {
    return SeparatorElement(
      adaptiveMap: adaptiveMap,
      child: LayoutBuilder(builder: (context, constraints) {
        return Wrap(
          //maxCrossAxisExtent: 200.0,
          children: images
              .map((img) =>
                  SizedBox(width: calculateSize(constraints), child: img))
              .toList(),
          //shrinkWrap: true,
        );
      }),
    );
  }

  double calculateSize(BoxConstraints constraints) {
    if (maybeSize != null) return maybeSize;
    if (imageSize == "stretch") return constraints.maxWidth;
    // Display a maximum of 5 children
    if (images.length >= 5) {
      return constraints.maxWidth / 5;
    } else if (images.length == 0) {
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
    int size = resolver.resolve("imageSizes", sizeDescription);
    maybeSize = size.toDouble();
  }
}

class AdaptiveMedia extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveMedia({Key key, this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveMediaState createState() => _AdaptiveMediaState();
}

class _AdaptiveMediaState extends State<AdaptiveMedia>
    with AdaptiveElementMixin {
  VideoPlayerController videoPlayerController;
  ChewieController controller;

  String sourceUrl;
  String postUrl;
  String altText;

  FadeAnimation imageFadeAnim = FadeAnimation(
    child: const Icon(Icons.play_arrow, size: 100.0),
  );

  @override
  void initState() {
    super.initState();

    postUrl = adaptiveMap["poster"];
    sourceUrl = adaptiveMap["sources"][0]["url"];
    videoPlayerController = VideoPlayerController.network(sourceUrl);

    controller = ChewieController(
      aspectRatio: 3 / 2,
      autoPlay: false,
      looping: true,
      autoInitialize: true,
      placeholder:
          postUrl != null ? Center(child: Image.network(postUrl)) : SizedBox(),
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.pause();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SeparatorElement(
        adaptiveMap: adaptiveMap,
        child: Chewie(
          controller: controller,
        ));
  }
}

/// Element for an unknown type
///
/// This Element is returned when an unknown element type is encountered.
///
/// When in production, these are blank elements which don't render anything.
///
/// In debug mode these contain an error message describing the problem.
class AdaptiveUnknown extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveUnknown({Key key, this.adaptiveMap, this.type}) : super(key: key);

  final Map adaptiveMap;

  final String type;

  @override
  _AdaptiveUnknownState createState() => _AdaptiveUnknownState();
}

class _AdaptiveUnknownState extends State<AdaptiveUnknown>
    with AdaptiveElementMixin {
  @override
  Widget build(BuildContext context) {
    Widget result = SizedBox();

    // Only do this in debug mode
    assert(() {
      result = ErrorWidget("Type ${widget.type} not found. \n\n"
          "Because of this, a portion of the tree was dropped: \n"
          "$adaptiveMap");

      return true;
    }());

    return result;
  }
}
