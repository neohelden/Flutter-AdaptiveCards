import 'dart:collection';

import 'package:flutter/cupertino.dart';

/// Keeps the size of the CrossNetworkImages in sync.
class ImageSizeNotifier extends ChangeNotifier {
  final Map _imageHeight = HashMap<String, int>();
  final Map _imageWidth = HashMap<String, int>();

  /// Whether a size for the given url exists or not.
  bool contains(String url) => _imageHeight.containsKey(url);

  /// Returns the height for the given url or null.
  int? getHeightFor(String url) => _imageHeight[url];

  /// Returns the width for the given url or null.
  int? getWidthFor(String url) => _imageWidth[url];

  /// Sets the size for the given url.
  void setSizeFor(String url, {required int height, required int width}) {
    _imageHeight[url] = height;
    _imageWidth[url] = width;
    notifyListeners();
  }
}
