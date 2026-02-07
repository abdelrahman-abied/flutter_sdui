import 'package:flutter/material.dart';
import 'package:sdui_project/sdui/sdui_parser.dart';
import '../utils/style_parser.dart';

class SDUIContainer extends StatelessWidget {
  final Map<String, dynamic> uiJson;

  const SDUIContainer({super.key, required this.uiJson});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> style = uiJson['style'] ?? {};
    final List<dynamic> children = uiJson['children'] ?? [];

    // 1. Apply Margin (Outer Spacing)
    return Padding(
      padding: StyleParser.parseInsets(style, 'margin'),
      child: Container(
        // 2. Apply Decoration (Color, Radius, Shadow)
        decoration: StyleParser.parseDecoration(style),

        // 3. Apply Padding (Inner Spacing)
        padding: StyleParser.parseInsets(style, 'padding'),

        // 4. Render Children (Depending on layout type, we might column them)
        // If there's only one child, return it. If multiple, default to Column.
        child: children.length == 1
            ? SDUIParser(uiJson: children[0])
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children.map((item) => SDUIParser(uiJson: item)).toList(),
              ),
      ),
    );
  }
}
