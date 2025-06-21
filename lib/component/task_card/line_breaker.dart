import 'package:flutter/material.dart';
import 'package:protask/theme/my_color.dart';

class CustomEllipsisText extends StatelessWidget {
  final String text;
  final int maxLines;
  final TextStyle style;

  const CustomEllipsisText({
    super.key,
    required this.text,
    this.maxLines = 2,
    this.style = const TextStyle(fontSize: 12, color: MyColor.black),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        if (textPainter.didExceedMaxLines) {
          String trimmedText = text;
          while (textPainter.didExceedMaxLines) {
            trimmedText = trimmedText.substring(0, trimmedText.length - 1);
            textPainter.text = TextSpan(text: "$trimmedText...", style: style);
            textPainter.layout(maxWidth: constraints.maxWidth);
          }

          return Text(
            "$trimmedText...",
            maxLines: maxLines,
            overflow: TextOverflow.visible,
            style: style.copyWith(fontWeight: FontWeight.bold),
          );
        } else {
          return Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: style,
          );
        }
      },
    );
  }
}
