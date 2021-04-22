import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../flutter_adaptive_cards.dart';

/// Fades in the [child].
class FadeAnimation extends StatefulWidget {

  /// Creates a FadeAnimation widget.
  FadeAnimation({
    this.child,
    this.duration = const Duration(milliseconds: 500),
  });

  /// The child which gets faded in.
  final Widget? child;

  /// The duration of the fade animation.
  final Duration duration;

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
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

/// Makes the first char of a string lower case.
String firstCharacterToLowerCase(String s) =>
    s.isNotEmpty ? s[0].toLowerCase() + s.substring(1) : "";

/// A clipper to display round images.
class FullCircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0.0, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}

/// Parses a string to a color.
Color? parseColor(String? colorValue) {
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

/// Gets the correct english day suffix for the [dayOfMonth].
String getDayOfMonthSuffix(final int dayOfMonth) {
  assert(
    dayOfMonth >= 1 && dayOfMonth <= 31,
    "illegal day of month: $dayOfMonth",
  );

  if (dayOfMonth >= 11 && dayOfMonth <= 13) {
    return "th";
  }
  switch (dayOfMonth % 10) {
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

/// Gets the background color based on the AdaptiveElement configuration
/// and its parent container.
Color? getBackgroundColorIfNoBackgroundImageAndNoDefaultStyle({
  ReferenceResolver? resolver,
  required Map adaptiveMap,
  Brightness? brightness,
}) {
  if (adaptiveMap["backgroundImage"] != null) return null;

  var style = adaptiveMap["style"] ?? "default";
  if (style == "default") return null;

  return getBackgroundColor(
    resolver: resolver!,
    adaptiveMap: adaptiveMap,
    brightness: brightness,
  );
}

/// Gets the background color of the parent container.
Color? getBackgroundColor({
  required ReferenceResolver resolver,
  Map? adaptiveMap,
  Brightness? brightness,
}) {
  var style = adaptiveMap?["style"]?.toString().toLowerCase() ?? "default";

  String? color =
      resolver.hostConfig!["containerStyles"][style]["backgroundColor"];
  var backgroundColor = parseColor(color);
  return backgroundColor;
}

/// Parses a given text string to property handle DATE() and TIME()
/// TODO this needs a bunch of tests
String parseTextString(String text) {
  return text.replaceAllMapped(RegExp(r'{{.*}}'), (match) {
    var res = match.group(0)!;
    var input = res.substring(2, res.length - 2);
    input = input.replaceAll(" ", "");

    var type = input.substring(0, 4);
    if (type == "DATE") {
      var dateFunction = input.substring(5, input.length - 1);
      var items = dateFunction.split(",");
      if (items.length == 1) {
        items.add("COMPACT");
      }
      //if(items.length != 2) throw StateError("$dateFunction is not valid");
      // Wrong format
      if (items.length != 2) return res;

      var dateTime = DateTime.tryParse(items[0]);

      // TODO use locale
      DateFormat dateFormat;

      if (dateTime == null) return res;
      if (items[1] == "COMPACT") {
        dateFormat = DateFormat.yMd();
        return dateFormat.format(dateTime);
      } else if (items[1] == "SHORT") {
        dateFormat = DateFormat("E, MMM d{n}, y");
        return dateFormat
            .format(dateTime)
            .replaceFirst('{n}', getDayOfMonthSuffix(dateTime.day));
      } else if (items[1] == "LONG") {
        dateFormat = DateFormat("EEEE, MMMM d{n}, y");
        return dateFormat
            .format(dateTime)
            .replaceFirst('{n}', getDayOfMonthSuffix(dateTime.day));
      } else {
        // Wrong format
        return res;
      }
    } else if (type == "TIME") {
      var time = input.substring(5, input.length - 1);
      var dateTime = DateTime.tryParse(time);
      if (dateTime == null) return res;

      var dateFormat = DateFormat("jm");

      return dateFormat.format(dateTime);
    } else {
      // Wrong format
      return res;
      //throw StateError("Function $type not found");
    }
  });
}

/// Generates a uuid.
class UUIDGenerator {
  final Uuid _uuid = Uuid();

  /// Returns a random uuid.
  String getId() {
    return _uuid.v1();
  }
}
