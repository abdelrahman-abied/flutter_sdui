// lib/main.dart
import 'package:flutter/material.dart';
import 'package:sdui_project/sdui/sdui_paarser.dart';

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
    "screen_title": "Home",
    "ui_tree": {
      "type": "VERTICAL_STACK",
      "children": [
        {
          "type": "HEADER",
          "props": {
            "title": "Welcome Back, User!",
            "icon_url": "https://img.icons8.com/color/96/user.png"
          }
        },
        {
          "type": "BANNER_CARD",
          "props": {
            "image_url": "https://picsum.photos/seed/picsum/600/300",
            "aspect_ratio": 1.5
          },
          "action": { "type": "NAVIGATE", "destination": "promo" }
        },
        {
          "type": "TEXT",
          "props": { "text": "Recommended for you", "style": "h2" }
        },
        {
          "type": "HORIZONTAL_SCROLL",
          "children": [
            {
              "type": "PRODUCT_CARD",
              "props": { "name": "Wireless Headphones", "price": "\$99" },
              "action": { "type": "SHOW_TOAST", "payload": { "message": "Added" } }
            },
            {
              "type": "PRODUCT_CARD",
              "props": { "name": "Smart Watch", "price": "\$150" }
            },
            {
              "type": "PRODUCT_CARD",
              "props": { "name": "Gaming Mouse", "price": "\$45" }
            }
          ]
        }
      ]
    }
  };

  @override
  Widget build(BuildContext context) {
    // Start parsing from the root 'ui_tree'
    return SafeArea(
      child: SingleChildScrollView(
        child: SDUIParser(uiJson: serverResponse['ui_tree']),

      ),
    );
  }
}