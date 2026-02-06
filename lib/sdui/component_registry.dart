// lib/sdui/component_registry.dart
import 'package:flutter/material.dart';
import '../components/sdui_components.dart';

// 1. Define the signature of a decoder function
typedef SDUIWidgetBuilder = Widget Function(
  Map<String, dynamic> props, 
  List<Widget> children
);

class ComponentRegistry {
  
  // 2. The Lookup Map
  static final Map<String, SDUIWidgetBuilder> _registry = {
    
    // Layout Components
    'VERTICAL_STACK': (props, children) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: children
    ),
    
    'HORIZONTAL_SCROLL': (props, children) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: children),
    ),

    // UI Components (Mapping JSON props to Widget arguments)
    'HEADER': (props, _) => SDUIHeader(
      title: props['title'] ?? '',
      iconUrl: props['icon_url'] ?? '',
    ),
    
    'BANNER_CARD': (props, _) => SDUIBanner(
      imageUrl: props['image_url'] ?? '',
    ),
    
    'PRODUCT_CARD': (props, _) => SDUIProductCard(
      name: props['name'] ?? 'Unknown',
      price: props['price'] ?? '',
    ),
    
    'TEXT': (props, _) => Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        props['text'] ?? '',
        style: props['style'] == 'h2' 
            ? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold) 
            : const TextStyle(fontSize: 14),
      ),
    ),
  };

  // 3. The Lookup Method
  static SDUIWidgetBuilder? getWidgetBuilder(String type) {
    return _registry[type];
  }
}