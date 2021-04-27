library flutter_adaptive_cards;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'action_handler.dart';
import 'base.dart';
import 'registry.dart';
import 'utils.dart';

/// An abstract provider for the adaptive card host config
abstract class AdaptiveCardContentProvider {
  /// Provides the content and the host config for the adaptive card.
  AdaptiveCardContentProvider({this.hostConfigPath, this.hostConfig});

  /// The path to a host config.
  final String? hostConfigPath;
  /// The host config as a string.
  final String? hostConfig;

  /// Loads the host config.
  Future<Map?> loadHostConfig() async {
    if (hostConfig != null) {
      var cleanedHostConfig = hostConfig!.replaceAll(RegExp(r'\n'), '');
      return json.decode(cleanedHostConfig);
    }

    var hostConfigString = await rootBundle.loadString(hostConfigPath!);
    return json.decode(hostConfigString);
  }

  /// Loads the card content.
  Future<Map?> loadAdaptiveCardContent();
}

/// Provides the adaptive card content directly.
class MemoryAdaptiveCardContentProvider extends AdaptiveCardContentProvider {

  /// Creates a MemoryAdaptiveCardContentProvider.
  MemoryAdaptiveCardContentProvider(
      {required this.content, String? hostConfigPath, String? hostConfig})
      : super(hostConfigPath: hostConfigPath, hostConfig: hostConfig);

  /// The adaptive card content.
  Map content;

  @override
  Future<Map> loadAdaptiveCardContent() {
    return Future.value(content);
  }
}

/// Provides the adaptive card content from an assets path.
class AssetAdaptiveCardContentProvider extends AdaptiveCardContentProvider {

  /// Creates an AssetAdaptiveCardContentProvider.
  AssetAdaptiveCardContentProvider(
      {required this.path, String? hostConfigPath, String? hostConfig})
      : super(hostConfigPath: hostConfigPath, hostConfig: hostConfig);

  /// The asset path of the adaptive card content.
  String path;

  @override
  Future<Map?> loadAdaptiveCardContent() async {
    return json.decode(await rootBundle.loadString(path));
  }
}

/// Provides the adaptive card content from an url.
class NetworkAdaptiveCardContentProvider extends AdaptiveCardContentProvider {

  /// Creates an NetworkAdaptiveCardContentProvider.
  NetworkAdaptiveCardContentProvider(
      {required this.url, String? hostConfigPath, String? hostConfig})
      : super(hostConfigPath: hostConfigPath, hostConfig: hostConfig);

  /// The url of the adaptive card content.
  String url;

  @override
  Future<Map?> loadAdaptiveCardContent() async {
    return json.decode((await http.get(Uri.dataFromString(url))).body);
  }
}

/// The AdaptiveCard widget.
class AdaptiveCard extends StatefulWidget {

  /// Creates an AdaptiveCard widget.
  AdaptiveCard({
    Key? key,
    required this.adaptiveCardContentProvider,
    this.placeholder,
    this.cardRegistry,
    this.onSubmit,
    this.onOpenUrl,
    this.hostConfig,
    this.listView = false,
    this.showDebugJson = true,
    this.approximateDarkThemeColors = true,
    this.supportMarkdown = true,
  }) : super(key: key);

  /// Creates an AdaptiveCard from an url.
  AdaptiveCard.network({
    Key? key,
    this.placeholder,
    this.cardRegistry,
    required String url,
    required String hostConfigPath,
    this.hostConfig,
    this.onSubmit,
    this.onOpenUrl,
    this.listView = false,
    this.showDebugJson = true,
    this.approximateDarkThemeColors = true,
    this.supportMarkdown = true,
  }) : adaptiveCardContentProvider = NetworkAdaptiveCardContentProvider(
            url: url, hostConfigPath: hostConfigPath, hostConfig: hostConfig);

  /// Creates an AdaptiveCard from the project assets.
  AdaptiveCard.asset({
    Key? key,
    this.placeholder,
    this.cardRegistry,
    required String assetPath,
    required String hostConfigPath,
    this.hostConfig,
    this.onSubmit,
    this.onOpenUrl,
    this.listView = false,
    this.showDebugJson = true,
    this.approximateDarkThemeColors = true,
    this.supportMarkdown = true,
  }) : adaptiveCardContentProvider = AssetAdaptiveCardContentProvider(
            path: assetPath,
            hostConfigPath: hostConfigPath,
            hostConfig: hostConfig);

  /// Creates an AdaptiveCard directly form a given [content].
  AdaptiveCard.memory({
    Key? key,
    this.placeholder,
    this.cardRegistry,
    required Map content,
    required String hostConfigPath,
    this.hostConfig,
    this.onSubmit,
    this.onOpenUrl,
    this.listView = false,
    this.showDebugJson = true,
    this.approximateDarkThemeColors = true,
    this.supportMarkdown = true,
  }) : adaptiveCardContentProvider = MemoryAdaptiveCardContentProvider(
            content: content,
            hostConfigPath: hostConfigPath,
            hostConfig: hostConfig);

  /// The content provider of the adaptive card.
  final AdaptiveCardContentProvider adaptiveCardContentProvider;

  /// The placeholder shown as long as the AdaptiveCard isn't loaded.
  final Widget? placeholder;

  /// The card registry.
  final CardRegistry? cardRegistry;

  /// The host config.
  ///
  /// The host config is a json file used to theme the adaptive card.
  final String? hostConfig;

  /// A callback function called when an onSumbit action is triggered.
  final Function(Map? map)? onSubmit;

  /// A callback function called when an onOpenUrl action is triggered.
  final Function(String? url)? onOpenUrl;

  /// Whether debug json is shown under the adaptive card.
  final bool showDebugJson;

  /// Whether the adaptive card approximateDarkThemeColors.
  final bool approximateDarkThemeColors;

  /// Whether the adaptive cards renders markdown.
  final bool supportMarkdown;

  /// Whether a scrollable list view is used instead of a column.
  ///
  /// Set to false if the list view is already wrapped in a scrollable widget.
  final bool listView;

  @override
  _AdaptiveCardState createState() => _AdaptiveCardState();
}

class _AdaptiveCardState extends State<AdaptiveCard> {
  Map? map;
  Map? hostConfig;

  late CardRegistry cardRegistry;

  Function(Map? map)? onSubmit;
  Function(String? url)? onOpenUrl;

  @override
  void initState() {
    super.initState();
    widget.adaptiveCardContentProvider.loadHostConfig().then((hostConfigMap) {
      if (mounted) {
        setState(() {
          hostConfig = hostConfigMap;
        });
      }
    });
    widget.adaptiveCardContentProvider
        .loadAdaptiveCardContent()
        .then((adaptiveMap) {
      if (mounted) {
        setState(() {
          map = adaptiveMap;
        });
      }
    });
  }

  @override
  void didUpdateWidget(AdaptiveCard oldWidget) {
    widget.adaptiveCardContentProvider.loadHostConfig().then((hostConfigMap) {
      if (mounted) {
        setState(() {
          hostConfig = hostConfigMap;
        });
      }
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.cardRegistry != null) {
      cardRegistry = widget.cardRegistry!;
    } else {
      var cardRegistry = DefaultCardRegistry.of(context);
      if (cardRegistry != null) {
        this.cardRegistry = cardRegistry;
      } else {
        this.cardRegistry = CardRegistry(
          supportMarkdown: widget.supportMarkdown,
        );
      }
    }

    if (widget.onSubmit != null) {
      onSubmit = widget.onSubmit;
    } else {
      var foundOnSubmit = DefaultAdaptiveCardHandlers.of(context)?.onSubmit;
      if (foundOnSubmit != null) {
        onSubmit = foundOnSubmit;
      } else {
        onSubmit = (it) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("No handler found for: \n$it"),
          ));
        };
      }
    }

    if (widget.onOpenUrl != null) {
      onOpenUrl = widget.onOpenUrl;
    } else {
      var foundOpenUrl = DefaultAdaptiveCardHandlers.of(context)?.onOpenUrl;
      if (foundOpenUrl != null) {
        onOpenUrl = foundOpenUrl;
      } else {
        onOpenUrl = (it) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("No handler found for: \n$it"),
          ));
        };
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (map == null || hostConfig == null) {
      return widget.placeholder ?? const SizedBox();
    }
    return RawAdaptiveCard.fromMap(
      map,
      hostConfig,
      cardRegistry: cardRegistry,
      onOpenUrl: onOpenUrl,
      onSubmit: onSubmit,
      listView: widget.listView,
      showDebugJson: widget.showDebugJson,
      approximateDarkThemeColors: widget.approximateDarkThemeColors,
    );
  }
}

/// Main entry point to adaptive cards.
///
/// This widget takes a [map] (which usually is just a json decoded string) and
/// displays in natively. Additionally a host config needs to be provided for
/// styling.
class RawAdaptiveCard extends StatefulWidget {

  /// Creates an RawAdaptiveCard from a map.
  RawAdaptiveCard.fromMap(
    this.map,
    this.hostConfig, {
    this.cardRegistry = const CardRegistry(),
    required this.onSubmit,
    required this.onOpenUrl,
    required this.listView,
    this.showDebugJson = true,
    this.approximateDarkThemeColors = true,
  }) : assert(onSubmit != null, onOpenUrl != null);

  /// The configuration map.
  final Map? map;

  /// The host config.
  final Map? hostConfig;

  /// The registry.
  final CardRegistry cardRegistry;

  /// The callback function called when onSubmit is triggered.
  final Function(Map? map)? onSubmit;
  ///  The callback function called when openUrl is triggered.
  final Function(String? url)? onOpenUrl;

  /// Whether the json of the card is shown.
  final bool showDebugJson;
  /// Whether dark theme colors are approximated.
  final bool approximateDarkThemeColors;
  /// Whether the AdaptiveCard uses a ListView instead of a Column.
  final bool listView;

  @override
  RawAdaptiveCardState createState() => RawAdaptiveCardState();
}

/// The state of the adaptive card.
class RawAdaptiveCardState extends State<RawAdaptiveCard> {
  // Wrapper around the host config
  late ReferenceResolver _resolver;

  /// A generator for random ids.
  late UUIDGenerator idGenerator;

  /// The card registry.
  late CardRegistry cardRegistry;

  // The root element
  late Widget? _adaptiveElement;

  @override
  void initState() {
    super.initState();

    _resolver = ReferenceResolver(
      hostConfig: widget.hostConfig,
    );

    idGenerator = UUIDGenerator();
    cardRegistry = widget.cardRegistry;

    _adaptiveElement = widget.cardRegistry.getElement(
        widget.map as Map<String, dynamic>,
        listView: widget.listView);
  }

  void didUpdateWidget(RawAdaptiveCard oldWidget) {
    _resolver = ReferenceResolver(
      hostConfig: widget.hostConfig,
    );
    _adaptiveElement = widget.cardRegistry.getElement(
        widget.map as Map<String, dynamic>,
        listView: widget.listView);
    super.didUpdateWidget(oldWidget);
  }

  /// Every widget can access method of this class, meaning setting the state
  /// is possible from every element
  void rebuild() {
    setState(() {});
  }

  /// Submits all the inputs of this adaptive card, does it by recursively
  /// visiting the elements in the tree
  void submit(Map? map) {
    var visitor;
    visitor = (element) {
      if (element is StatefulElement) {
        if (element.state is AdaptiveInputMixin) {
          (element.state as AdaptiveInputMixin).appendInput(map);
        }
      }
      element.visitChildren(visitor);
    };
    context.visitChildElements(visitor);

    if (widget.onSubmit != null) {
      widget.onSubmit!(map);
    }
  }

  /// Calls the openUrl callback.
  void openUrl(String? url) {
    widget.onOpenUrl!(url);
  }

  /// Shows an error message.
  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  /// min and max dates may be null, in this case no constraint is made in
  /// that direction
  Future<DateTime?> pickDate(DateTime? min, DateTime? max) {
    var initialDate = DateTime.now();
    return showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: min ?? DateTime.now().subtract(Duration(days: 10000)),
        lastDate: max ?? DateTime.now().add(Duration(days: 10000)));
  }

  /// Opens a time picker and returns the picked time.
  Future<TimeOfDay?> pickTime() {
    var initialTimeOfDay = TimeOfDay.now();
    return showTimePicker(context: context, initialTime: initialTimeOfDay);
  }

  @override
  Widget build(BuildContext context) {
    var child = _adaptiveElement;

    assert(() {
      if (widget.showDebugJson) {
        child = Column(
          children: [
            TextButton(
              style: TextButton.styleFrom(primary: Colors.indigo),
              onPressed: () {
                var encoder = JsonEncoder.withIndent('  ');
                var prettyprint = encoder.convert(widget.map);
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                            "JSON (only added in debug mode, you can also turn"
                            "it of manually by passing showDebugJson = false)"),
                        content:
                            SingleChildScrollView(child: Text(prettyprint)),
                        actions: <Widget>[
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("Thanks"),
                            ),
                          )
                        ],
                        contentPadding: EdgeInsets.all(8.0),
                      );
                    });
              },
              child: Text("Debug show the JSON"),
            ),
            Divider(
              height: 0,
            ),
            child ?? SizedBox(width: 1),
          ],
        );
      }
      return true;
    }());
    var backgroundColor = getBackgroundColor(
      resolver: _resolver,
      adaptiveMap: widget.map,
      brightness: Theme.of(context).brightness,
    );

    return Provider<RawAdaptiveCardState>.value(
      value: this,
      child: InheritedReferenceResolver(
        resolver: _resolver,
        child: Card(
          color: backgroundColor,
          child: child,
        ),
      ),
    );
  }
}

/// The visitor, the function is called once for every element in the tree
typedef AdaptiveElementVisitor = void Function(AdaptiveElement element);

/// The base class for every element (widget) drawn on the screen.
///
/// The lifecycle is as follows:
/// - [loadTree()] is called, all the initialization should be done here
/// - [generateWidget()] is called every time the elements needs to render
/// this method should be as lightweight as possible because it could possibly
/// be called many times (for example in an animation). The method should also
/// be idempotent meaning calling it multiple times without changing anything
/// should return the same result
///
/// This class also holds some references every element needs.
/// --------------------------------------------------------------------
/// The [adaptiveMap] is the map associated with that element
///
/// root
/// |
/// currentElement <-- ([adaptiveMap] contains the subtree from there)
/// |       |
/// child 1 child2
/// --------------------------------------------------------------------
///
/// The [resolver] is a handy wrapper around the hostConfig, which makes
/// accessing it easier.
///
/// The [widgetState] provides access to flutter specific implementations.
///
/// If the element has children (you don't need to do this if the element is a
/// leaf):
/// implement the method [visitChildren] and call visitor(this) in addition call
/// [visitChildren] on each child with the passed visitor.
@immutable
abstract class AdaptiveElement {

  /// The map of an element.
  final Map adaptiveMap;

  /// The id of the AdaptiveElement.
  late final String? id;

  /// Because some widgets (looking at you ShowCardAction) need to set the state
  /// all elements get a way to set the state.
  final RawAdaptiveCardState widgetState;

  /// Creates an AdaptiveElement.
  AdaptiveElement({required this.adaptiveMap, required this.widgetState}) {
    if (adaptiveMap.containsKey("id")) {
      id = adaptiveMap["id"];
    } else {
      id = widgetState.idGenerator.getId();
    }
  }

  /// This method should be implemented by the actual elements to return
  /// their Flutter representation.
  Widget build();

  /// Use this method to obtain the widget tree of the adaptive card.
  ///
  /// Each mixin has the opportunity to add something to the widget hierarchy.
  ///
  /// An example:
  /// @override
  /// Widget generateWidget() {
  ///  assert(
  ///   separator != null,
  ///   "Did you forget to call loadSeperator in this class?",
  ///  );
  ///  return Column(
  ///    children: <Widget>[
  ///      separator ?
  ///       Divider(height: topSpacing) :
  ///       SizedBox(height: topSpacing),
  ///      super.generateWidget(),
  ///    ],
  ///  );
  ///}
  ///
  /// This works because each mixin calls [generateWidget] in its generateWidget
  /// and adds the returned value into the widget tree. Eventually the base
  /// implementation (this) will be called and the elements actual build method
  /// is included.
  @mustCallSuper
  Widget generateWidget() {
    return build();
  }

  /// Visits the children
  void visitChildren(AdaptiveElementVisitor visitor) {
    visitor(this);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdaptiveElement &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Resolves values based on the host config.
///
/// All values can also be null, in that case the default is used
class ReferenceResolver {

  /// Creates an ReferenceResolver.
  ReferenceResolver({
    this.hostConfig,
    this.currentStyle,
  });

  /// The host config.
  final Map? hostConfig;

  /// The current style.
  final String? currentStyle;

  /// Returns the value of [key] and its [value] of the host config.
  dynamic resolve(String key, String value) {
    dynamic res = hostConfig![key][firstCharacterToLowerCase(value)];
    assert(res != null,
        "Could not find hostConfig[$key][${firstCharacterToLowerCase(value)}]");
    return res;
  }

  /// Returns all values of a host config [key].
  dynamic get(String key) {
    dynamic res = hostConfig![key];
    assert(res != null, "Could not find hostConfig[$key]");
    return res;
  }

  /// Returns the font wight [value].
  FontWeight resolveFontWeight(String? value) {
    int weight = resolve("fontWeights", value ?? "default");
    var fontWeight = FontWeight.values.firstWhere(
        (possibleWeight) => possibleWeight.toString() == "FontWeight.w$weight");
    return fontWeight;
  }

  /// Returns the font size [value].
  double resolveFontSize(String? value) {
    int size = resolve("fontSizes", value ?? "default");
    return size.toDouble();
  }

  /// Resolves a color from the host config
  ///
  /// Typically one of the following colors:
  /// - default
  /// - dark
  /// - light
  /// - accent
  /// - good
  /// - warning
  /// - attention
  Color? resolveForegroundColor({String? colorType, bool? isSubtle}) {
    var myColor = colorType ?? "default";
    var subtleOrDefault = isSubtle ?? false ? "subtle" : "default";
    final style = currentStyle ?? "default";
    // Make it case insensitive
    String? colorValue = hostConfig!["containerStyles"][style]
            ["foregroundColors"][firstCharacterToLowerCase(myColor)]
        [subtleOrDefault];
    return parseColor(colorValue);
  }

  /// Creates a copy of ReferenceResolver with the [style].
  ReferenceResolver copyWith({String? style}) {
    assert(style == null || style == "default" || style == "emphasis");
    var myStyle = style ?? "default";
    return ReferenceResolver(
      hostConfig: hostConfig,
      currentStyle: myStyle,
    );
  }

  /// Converts the spacing attribute to an double.
  double resolveSpacing(String? spacing) {
    var mySpacing = spacing ?? "default";
    if (mySpacing == "none") return 0.0;
    int intSpacing =
        hostConfig!["spacing"][firstCharacterToLowerCase(mySpacing)];
    return intSpacing.toDouble();
  }
}
