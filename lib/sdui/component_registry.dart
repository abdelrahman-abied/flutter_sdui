import 'package:flutter/material.dart';
import 'package:sdui_project/sdui/sdui_parser.dart';
import '../components/sdui_components.dart';
import '../components/sdui_container.dart'; // Import Container
import '../components/sdui_grid.dart'; // Import Grid
import '../utils/style_parser.dart'; // Import Parser

typedef SDUIWidgetBuilder = Widget Function(Map<String, dynamic> node);

class ComponentRegistry {
  static final Map<String, SDUIWidgetBuilder> _registry = {
    // Layouts
    'VERTICAL_STACK': (node) => Column(children: (node['children'] as List).map((c) => SDUIParser(uiJson: c)).toList()),

    // New: Generic Container (Div)
    'CONTAINER': (node) => SDUIContainer(uiJson: node),

    // New: Grids
    'GRID_2_COL': (node) => SDUIGrid(uiJson: node, crossAxisCount: 2),

    // Components
    'HEADER': (node) => SDUIHeader(title: node['props']['title'], iconUrl: node['props']['icon_url']),

    'BANNER_CARD': (node) => SDUIBanner(imageUrl: node['props']['image_url']),

    'PRODUCT_CARD': (node) => SDUIProductCard(name: node['props']['name'], price: node['props']['price']),

    // Update Text to handle Colors and Sizes
    'TEXT': (node) {
      final style = node['style'] ?? {};
      return Padding(
        padding: StyleParser.parseInsets(style, 'margin'),
        child: Text(
          node['props']['text'] ?? '',
          style: TextStyle(
            fontSize: (style['font_size'] ?? 14).toDouble(),
            fontWeight: style['font_weight'] == 'bold' ? FontWeight.bold : FontWeight.normal,
            color: StyleParser.parseColor(style['color']) ?? Colors.black,
          ),
        ),
      );
    },
  };

  static SDUIWidgetBuilder? getWidgetBuilder(String type) {
    return _registry[type];
  }
}
