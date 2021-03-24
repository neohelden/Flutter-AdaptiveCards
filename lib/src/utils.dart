import 'package:flutter/material.dart';
import 'package:flutter_adaptive_cards/flutter_adaptive_cards.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class FadeAnimation extends StatefulWidget {
  FadeAnimation({this.child, this.duration = const Duration(milliseconds: 500)});

  final Widget child;
  final Duration duration;

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation> with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: widget.duration, vsync: this);
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return animationController.isAnimating
        ? Opacity(
            opacity: 1.0 - animationController.value,
            child: widget.child,
          )
        : Container();
  }
}

String firstCharacterToLowerCase(String s) => s.isNotEmpty ? s[0].toLowerCase() + s.substring(1) : "";

class Tuple<A, B> {
  final A a;
  final B b;

  Tuple(this.a, this.b);
}

class FullCircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0.0, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}

Color parseColor(String colorValue) {
  if (colorValue == null) return null;
  // No alpha
  if (colorValue.length == 7) {
    return Color(int.parse(colorValue.substring(1, 7), radix: 16) + 0xFF000000);
  } else if (colorValue.length == 9) {
    return Color(int.parse(colorValue.substring(1, 9), radix: 16));
  } else {
    throw StateError("$colorValue is not a valid color");
  }
}

String getDayOfMonthSuffix(final int n) {
  assert(n >= 1 && n <= 31, "illegal day of month: " + n.toString());
  if (n >= 11 && n <= 13) {
    return "th";
  }
  switch (n % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
}

Color adjustColorToFitDarkTheme(Color color, Brightness brightness) {
  if (color == null) return null;

  return color;
  // TODO add tiny color when null safety version is released
 /* if (brightness == Brightness.light) {
    return color;
  } else {
    TinyColor tinyColor = TinyColor(color);
    double luminance = tinyColor.getLuminance();
    if (tinyColor.isDark()) return tinyColor.lighten(((1 - luminance) * 100).round()).color;
    if (tinyColor.isLight()) return tinyColor.darken(((0 + luminance) * 100).round()).color;
    return color;
  }*/
}

Color getBackgroundColorIfNoBackgroundImageAndNoDefaultStyle({
  ReferenceResolver resolver,
  Map adaptiveMap,
  bool approximateDarkThemeColors,
  Brightness brightness,
}) {
  if (adaptiveMap["backgroundImage"] != null) return null;

  var style = adaptiveMap["style"] ?? "default";
  if (style == "default") return null;

  return getBackgroundColor(resolver, adaptiveMap, approximateDarkThemeColors, brightness);
}

Color getBackgroundColor(
  ReferenceResolver resolver,
  Map adaptiveMap,
  bool approximateDarkThemeColors,
  Brightness brightness,
) {
  String style = adaptiveMap["style"]?.toString()?.toLowerCase() ?? "default";

  String color = resolver.hostConfig["containerStyles"][style]["backgroundColor"];

  var backgroundColor = parseColor(color);
  if (backgroundColor != null && approximateDarkThemeColors) {
    backgroundColor = adjustColorToFitDarkTheme(backgroundColor, brightness);
  }
  return backgroundColor;
}

/// Parses a given text string to property handle DATE() and TIME()
/// TODO this needs a bunch of tests
String parseTextString(String text) {
  return text.replaceAllMapped(RegExp(r'{{.*}}'), (match) {
    String res = match.group(0);
    String input = res.substring(2, res.length - 2);
    input = input.replaceAll(" ", "");

    String type = input.substring(0, 4);
    if (type == "DATE") {
      String dateFunction = input.substring(5, input.length - 1);
      List<String> items = dateFunction.split(",");
      if (items.length == 1) {
        items.add("COMPACT");
      }
      //if(items.length != 2) throw StateError("$dateFunction is not valid");
      // Wrong format
      if (items.length != 2) return res;

      DateTime dateTime = DateTime.tryParse(items[0]);

      // TODO use locale
      DateFormat dateFormat;

      if (dateTime == null) return res;
      if (items[1] == "COMPACT") {
        dateFormat = DateFormat.yMd();
        return dateFormat.format(dateTime);
      } else if (items[1] == "SHORT") {
        dateFormat = DateFormat("E, MMM d{n}, y");
        return dateFormat.format(dateTime).replaceFirst('{n}', getDayOfMonthSuffix(dateTime.day));
      } else if (items[1] == "LONG") {
        dateFormat = DateFormat("EEEE, MMMM d{n}, y");
        return dateFormat.format(dateTime).replaceFirst('{n}', getDayOfMonthSuffix(dateTime.day));
      } else {
        // Wrong format
        return res;
      }
    } else if (type == "TIME") {
      String time = input.substring(5, input.length - 1);
      DateTime dateTime = DateTime.tryParse(time);
      if (dateTime == null) return res;

      DateFormat dateFormat = DateFormat("jm");

      return dateFormat.format(dateTime);
    } else {
      // Wrong format
      return res;
      //throw StateError("Function $type not found");
    }
  });
}

class UUIDGenerator {
  UUIDGenerator() : uuid = Uuid();

  final Uuid uuid;

  String getId() {
    return uuid.v1();
  }
}
