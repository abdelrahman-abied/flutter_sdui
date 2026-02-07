// lib/main.dart
import 'package:flutter/material.dart';
import 'package:sdui_project/sdui/sdui_parser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Server Driven UI")),
        body: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Normally this comes from an API. We hardcode it for Part 2.
  final Map<String, dynamic> serverResponse = {
    "screen_title": "Shop",
    "ui_tree": {
      "type": "VERTICAL_STACK",
      "children": [
        // 1. Search Bar Area (Styled Container)
        {
          "type": "CONTAINER",
          "style": {"padding": 16, "background_color": "#F0F0F0", "margin_bottom": 10},
          "children": [
            {
              "type": "CONTAINER",
              "style": {"background_color": "#FFFFFF", "corner_radius": 8, "padding": 12},
              "children": [
                {
                  "type": "TEXT",
                  "props": {"text": "Search Products..."},
                  "style": {"color": "#888888"},
                },
              ],
            },
          ],
        },

        // 2. Section Title
        {
          "type": "TEXT",
          "props": {"text": "New Arrivals"},
          "style": {"font_size": 22, "font_weight": "bold", "margin_left": 16, "margin_bottom": 10},
        },

        // 3. The Grid
        {
          "type": "GRID_2_COL",
          "style": {"padding": 16, "gap": 12},
          "children": [
            {
              "type": "CONTAINER",
              "style": {"background_color": "#E3F2FD", "corner_radius": 12, "padding": 8},
              "children": [
                {
                  "type": "PRODUCT_CARD",
                  "props": {"name": "Blue Shoes", "price": "\$120"},
                },
              ],
            },
            {
              "type": "CONTAINER",
              "style": {"background_color": "#FFEBEE", "padding": 8},
              "children": [
                {
                  "type": "PRODUCT_CARD",
                  "props": {"name": "Red Bag", "price": "\$80"},
                },
              ],
            },
            {
              "type": "CONTAINER",
              "style": {"background_color": "#E8F5E9", "corner_radius": 12, "padding": 8},
              "children": [
                {
                  "type": "PRODUCT_CARD",
                  "props": {"name": "Green Tea", "price": "\$12"},
                },
              ],
            },
          ],
        },
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    // Start parsing from the root 'ui_tree'
    return SafeArea(
      child: SingleChildScrollView(child: SDUIParser(uiJson: serverResponse['ui_tree'])),
    );
  }
}
