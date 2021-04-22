import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class BasicMarkdown extends MarkdownWidget {
  /// Creates a non-scrolling widget that parses and displays Markdown.
  const BasicMarkdown({
    Key? key,
    required String data,
    MarkdownStyleSheet? styleSheet,
    SyntaxHighlighter? syntaxHighlighter,
    MarkdownTapLinkCallback? onTapLink,
    String? imageDirectory,
    this.maxLines
  }) : super(
    key: key,
    data: data,
    styleSheet: styleSheet,
    syntaxHighlighter: syntaxHighlighter,
    onTapLink: onTapLink,
    imageDirectory: imageDirectory,
  );

  final int? maxLines;

  @override
  Widget build(BuildContext context, List<Widget>? children) {
    if (children!.length == 1)
      return children.single;

    //if(maxLines != null && )
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}