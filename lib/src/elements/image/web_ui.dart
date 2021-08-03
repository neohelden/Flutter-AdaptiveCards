
/// Allows conditional import of dart ui, allowing us to use images from other
/// servers for flutter web.
///
/// import 'package:cobra/utils/web_ui.dart' if (dart.library.html)
/// 'dart:ui' as ui;
///
/// Source:
/// https://github.com/flutter/flutter/issues/41563#issuecomment-626765363
// ignore: camel_case_types
class platformViewRegistry {
  // ignore: public_member_api_docs, type_annotate_public_apis
  static registerViewFactory(String viewId, dynamic cb) {}
}