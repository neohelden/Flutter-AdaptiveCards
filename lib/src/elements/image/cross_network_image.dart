import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';
import 'package:uuid/uuid.dart';

import 'image_size_notifier.dart';
import 'web_ui.dart' if (dart.library.html) 'dart:ui' as ui;

/// Loads images differently for web and mobile devices.
///
/// Uses Image.network() for android and iOS.
/// Uses HtmlElementView and ImageElement for web.
class CrossNetworkImage extends StatefulWidget {
  /// The url of the image.
  final String url;

  /// The fit of the image.
  final BoxFit? fit;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;

  /// Callback function returning the scaled height the image is shown with.
  final Function(double)? scaledHeightLoaded;

  /// Creates a [CrossNetworkImage].
  CrossNetworkImage({
    required this.url,
    this.fit,
    this.width,
    this.height,
    this.scaledHeightLoaded,
  });

  @override
  _CrossNetworkImageState createState() => _CrossNetworkImageState();
}

class _CrossNetworkImageState extends State<CrossNetworkImage> {
  int? _naturalHeight;
  int? _naturalWidth;
  double? _scaledHeight;
  double? _scaledWidth;
  StreamSubscription<Event>? _imageElementSubscription;
  ImageElement? _imageElement;
  void Function()? imageSizeListener;

  /// Used for caching the sizes of images rendered using a HtmlElement,
  /// due to images can't be registered a second time and they aren't
  /// disposed correctly by skia.

  static final imageSizeNotifier = ImageSizeNotifier();

  var uuid = Uuid().v4();

  @override
  void initState() {
    print("initState: $uuid");

    if (kIsWeb) {
      if (imageSizeNotifier.contains(widget.url)) {
        _naturalHeight = imageSizeNotifier.getHeightFor(widget.url);
        _naturalWidth = imageSizeNotifier.getWidthFor(widget.url);

        print("imageHeight.containsKey(widget.url) $uuid");

        _calculateScaledHeightAndWidth();

        WidgetsBinding.instance!.addPostFrameCallback((_) {
          if (widget.scaledHeightLoaded != null) {
            widget.scaledHeightLoaded!(_scaledHeight!);
          }
        });
      } else {
        imageSizeListener = () {
          if (imageSizeNotifier.contains(widget.url)) {
            _naturalHeight = imageSizeNotifier.getHeightFor(widget.url);
            _naturalWidth = imageSizeNotifier.getWidthFor(widget.url);

            _calculateScaledHeightAndWidth();
            setState(() {});

            if (widget.scaledHeightLoaded != null) {
              widget.scaledHeightLoaded!(_scaledHeight!);
            }
          }
        };
        imageSizeNotifier.addListener(imageSizeListener!);

        ui.platformViewRegistry.registerViewFactory(widget.url, (viewId) {
          _imageElement = ImageElement()..src = widget.url;
          print("new $viewId");

          _imageElementSubscription = _imageElement!.onLoad.listen((event) {
            // TODO is there a way to remove the view factory, when the widget
            // gets disposed?
            var imageElement = _imageElement;
            if (mounted && imageElement != null) {
              print("onload $uuid");
              imageSizeNotifier.setSizeFor(
                widget.url,
                height: imageElement.naturalHeight,
                width: imageElement.naturalWidth,
              );
            }
          });

          return _imageElement!;
        });
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      print("fit ${widget.fit}");
      if (widget.fit != null &&
          (widget.fit == BoxFit.scaleDown || widget.fit == BoxFit.contain)) {
        // Used in the image viewer screen
        print("_buildScaledDownWebImage $uuid");
        return _buildScaledDownWebImage(context);
      } else {
        print("_buildWebImage $uuid");
        return _buildWebImage(context);
      }
    } else {
      return Image.network(
        widget.url,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
      );
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      _imageElementSubscription?.cancel().whenComplete(() {
        _imageElementSubscription = null;
      });
      _imageElement = null;
      imageSizeNotifier.removeListener(imageSizeListener!);
    }

    super.dispose();
  }

  /// Scales the image so that the original aspect ratio is kept and it fits
  /// into its parent.
  Widget _buildScaledDownWebImage(BuildContext context) {
    var htmlImage = HtmlElementView(viewType: widget.url);

    var maxWidth = MediaQuery.of(context).size.width;
    var maxHeight = MediaQuery.of(context).size.height;

    print("Max size $maxWidth, $maxHeight");

    if (_hasNaturalSize()) {
      var scale = _naturalWidth! / _naturalHeight!;
      var widthFactor = _naturalWidth! / maxWidth;
      var scaledHeight = _naturalHeight! / widthFactor;
      var heightFactor = _naturalHeight! / maxHeight;
      var scaledWidth = _naturalWidth! / heightFactor;

      late double width, height;

      if (maxWidth >= _naturalWidth! && maxHeight >= _naturalHeight!) {
        width = _naturalWidth!.toDouble();
        height = _naturalHeight!.toDouble();
      } else if ((scale >= 1 && scaledHeight <= maxHeight) ||
          scaledWidth >= maxWidth) {
        // Wider than tall
        height = scaledHeight;
        width = maxWidth;
      } else {
        // Taller than wide
        width = scaledWidth;
        height = maxHeight;
      }

      print("Has natural size $width, $height");

      return sizedAspectRatioBox(
        width: width,
        height: height,
        child: htmlImage,
      );
    }

    return SizedBox(
      width: 1,
      height: 1,
      child: htmlImage,
    );
  }

  Widget _buildWebImage(BuildContext context) {
    var htmlImage = HtmlElementView(viewType: widget.url);

    print("width = ${widget.width} $uuid");
    print("height = ${widget.height} $uuid");
    if (_hasHeightAndWidth()) {
      print("_hasHeightAndWidth()");
      return sizedAspectRatioBox(
        width: widget.width!,
        height: widget.height!,
        child: htmlImage,
      );
    } else if (_hasOnlyWidth()) {
      print("_hasOnlyWidth");
      if (_hasNaturalSize()) {
        print("_hasNaturalSize $uuid");
        return sizedAspectRatioBox(
          width: widget.width!,
          height:  _scaledHeight ?? 1,
          child: htmlImage,
        );
      } else {
        return SizedBox(width: 1, height: 1, child: htmlImage);
      }
    } else if (_hasOnlyHeight()) {
      print("_hasOnlyHeight");
      if (_hasNaturalSize()) {
        print("_hasNaturalSize $uuid");
        return sizedAspectRatioBox(
          width: _scaledWidth ?? 1,
          height: widget.height!,
          child: htmlImage,
        );
      } else {
        return SizedBox(width: 1, height: 1, child: htmlImage);
      }
    } else {
      print("htmlImage");
      return htmlImage;
    }
  }

  void _calculateScaledHeightAndWidth() {
    if (_hasNaturalSize()) {
      if (_hasOnlyWidth()) {
        var scale = _naturalWidth! / widget.width!;
        _scaledHeight = _naturalHeight! / scale;
      } else if (_hasOnlyHeight()) {
        var scale = _naturalHeight! / widget.height!;
        _scaledWidth = _naturalWidth! / scale;
      }
    }
  }

  bool _hasHeightAndWidth() => widget.width != null && widget.height != null;

  bool _hasOnlyHeight() => widget.height != null && widget.width == null;

  bool _hasOnlyWidth() => widget.width != null && widget.height == null;

  bool _hasNaturalSize() => _naturalWidth != null && _naturalHeight != null;

  Widget sizedAspectRatioBox({
    required double width,
    required double height,
    required Widget child,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: height,
        maxWidth: width,
      ),
      child: AspectRatio(
        aspectRatio: (width / height),
        child: child,
      ),
    );
  }
}
