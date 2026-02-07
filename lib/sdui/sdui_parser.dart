// lib/sdui/sdui_parser.dart
import 'package:flutter/material.dart';
import 'component_registry.dart';

class SDUIParser extends StatelessWidget {
  final Map<String, dynamic> uiJson;

  const SDUIParser({super.key, required this.uiJson});

  @override
  Widget build(BuildContext context) {
    // 1. Safety Check
    if (uiJson.isEmpty) return const SizedBox.shrink();

    // 2. Extract Data
    final String type = uiJson['type'] ?? 'UNKNOWN';
    final Map<String, dynamic>? action = uiJson['action'];


    // 4. Get the Native Widget from Registry
    final builder = ComponentRegistry.getWidgetBuilder(type);

    if (builder == null) {
      // 5. Version Safety: Handle unknown components gracefully
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("⚠️ Unknown Component: $type", style: const TextStyle(color: Colors.red)),
      );
    }

    Widget nativeWidget = builder(uiJson);

    // 6. Wrap in Action Handler (if action exists)
    if (action != null) {
      return GestureDetector(
        onTap: () {
          print("Action Tapped: ${action['type']}"); // We will implement this in Part 4
        },
        child: nativeWidget,
      );
    }

    return nativeWidget;
  }
}