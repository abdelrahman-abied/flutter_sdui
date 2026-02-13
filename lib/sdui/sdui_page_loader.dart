import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'sdui_parser.dart';

class SDUIGenericPage extends StatefulWidget {
  final String endpoint; // e.g., "home" or "product/123"
  final Map<String, dynamic> initialData;

  const SDUIGenericPage({super.key, required this.endpoint, this.initialData = const {}});

  @override
  State<SDUIGenericPage> createState() => _SDUIGenericPageState();
}

class _SDUIGenericPageState extends State<SDUIGenericPage> {
  bool isLoading = true;
  Map<String, dynamic>? uiData;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPage();
  }

  Future<void> _fetchPage() async {
    // 1. Simulate Network Delay (skip for login - file load is fast)
    if (widget.endpoint != 'login') {
      await Future.delayed(const Duration(milliseconds: 800));
    }

    try {
      // 2. Fetch JSON (from assets or mock API)
      final json = await MockNetworkService.getJsonForEndpoint(widget.endpoint);

      if (mounted) {
        setState(() {
          uiData = json;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // A. Loading State
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // B. Error State
    if (errorMessage != null || uiData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(child: Text("Failed to load: $errorMessage")),
      );
    }

    // C. Success State - Render the JSON!
    return Scaffold(
      appBar: AppBar(title: Text(uiData!['screen_title'] ?? 'SDUI App')),
      body: SafeArea(
        child: SingleChildScrollView(child: SDUIParser(uiJson: Map<String, dynamic>.from(uiData!['ui_tree'] as Map))),
      ),
    );
  }
}

// --- MOCK NETWORK SERVICE ---
class MockNetworkService {
  static Future<Map<String, dynamic>> getJsonForEndpoint(String endpoint) async {
    // Login: Load from assets file
    if (endpoint == 'login') {
      final jsonStr = await rootBundle.loadString('assets/sdui/login.json');
      return Map<String, dynamic>.from(jsonDecode(jsonStr));
    }

    // Scenario A: Product Details
    if (endpoint.startsWith('product')) {
      return {
        "screen_title": "Product Details",
        "ui_tree": {
          "type": "VERTICAL_STACK",
          "children": [
            // Example 1: Simple Navigation
            {
              "type": "BANNER_CARD",
              "props": {
                "image_url":
                    "https://graphicsfamily.com/wp-content/uploads/edd/2021/07/Professional-E-Commerce-Shoes-Banner-Design-2048x1152.jpg",
              },
              "action": {
                "type": "navigate",
                "url": "/product/promo",
                "data": {"id": "promo_99", "referral": "home_banner"},
              },
            },

            // Example 2: Network Request (Add to Cart)
            {
              "type": "BUTTON_PRIMARY",
              "props": {"label": "Add to Cart - \$20.00"},
              "style": {"background_color": "#4CAF50"},
              "action": {
                "type": "network_request",
                "url": "https://api.myapp.com/cart/add",
                "data": {"sku": "ITEM_001", "qty": 1},
              },
            },

            // Example 3: Toast Message
            {
              "type": "TEXT",
              "props": {"text": "Need Help? Tap here."},
              "action": {
                "type": "show_toast",
                "data": {"message": "Opening Support Chat...", "is_error": false},
              },
            },
          ],
        },
      };
    }

    // Scenario B: Home Page (Default)
    return {
      "screen_title": "SDUI Home",
      "ui_tree": {
        "type": "VERTICAL_STACK",
        "children": [
          {
            "type": "HEADER",
            "props": {"title": "Welcome User", "icon_url": "https://img.icons8.com/color/96/user.png"},
          },
          {
            "type": "CONTAINER",
            "style": {"padding": 16, "background_color": "#E3F2FD", "margin": 16, "corner_radius": 12},
            "children": [
              {
                "type": "TEXT",
                "props": {"text": "Click below to test navigation"},
              },
            ],
          },
          {
            "type": "BUTTON_PRIMARY",
            "props": {"label": "Go to Product 123"},
            "style": {"background_color": "#2196F3"},
            "action": {
              "type": "navigate",
              "url": "/product/123", // <--- This triggers the deep link
              "data": {"referral": "home_page"},
            },
          },
        ],
      },
    };
  }
}
