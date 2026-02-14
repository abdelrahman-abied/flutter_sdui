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
  static const String _assetsBase = 'assets/sdui';

  /// Endpoint → asset file mapping. Add new screens here.
  static final Map<String, String> _endpointToAsset = {
    'login': '$_assetsBase/login.json',
    'products': '$_assetsBase/products.json',
    'home': '$_assetsBase/home.json',
  };

  /// Optional cache to avoid re-reading assets on repeated navigation.
  static final Map<String, Map<String, dynamic>> _cache = {};

  /// Loads and parses JSON from an asset path. Supports optional caching.
  static Future<Map<String, dynamic>> _loadJsonFromAsset(
    String path, {
    bool useCache = true,
  }) async {
    if (useCache && _cache.containsKey(path)) {
      return Map<String, dynamic>.from(_cache[path]!);
    }
    final jsonStr = await rootBundle.loadString(path);
    final data = Map<String, dynamic>.from(jsonDecode(jsonStr) as Map);
    if (useCache) _cache[path] = data;
    return data;
  }

  static Future<Map<String, dynamic>> getJsonForEndpoint(String endpoint) async {
    // Direct match
    final assetPath = _endpointToAsset[endpoint];
    if (assetPath != null) {
      return _loadJsonFromAsset(assetPath);
    }

    // Dynamic: product/123, product/promo, etc.
    if (endpoint.startsWith('product')) {
      return _loadJsonFromAsset('$_assetsBase/product_details.json');
    }

    // Default: home
    return _loadJsonFromAsset('$_assetsBase/home.json');
  }
}
