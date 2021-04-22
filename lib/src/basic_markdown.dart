import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// Creates a non-scrolling widget that parses and displays Markdown.
class BasicMarkdown extends MarkdownWidget {

  /// Creates a BasicMarkdown widget.
  const BasicMarkdown(
      {Key? key,
      required String data,
      MarkdownStyleSheet? styleSheet,
      SyntaxHighlighter? syntaxHighlighter,
      MarkdownTapLinkCallback? onTapLink,
      String? imageDirectory,
      this.maxLines})
      : super(
          key: key,
          data: data,
          styleSheet: styleSheet,
          syntaxHighlighter: syntaxHighlighter,
          onTapLink: onTapLink,
          imageDirectory: imageDirectory,
        );

  /// The maximum lines of the markdown text.
  final int? maxLines;

  @override
  Widget build(BuildContext context, List<Widget>? children) {
    if (children!.length == 1) return children.single;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
