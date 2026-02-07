import 'package:flutter/material.dart';
import 'sdui/sdui_page_loader.dart'; // Import the file we just made

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SDUI Deep Link Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      
      // We use onGenerateRoute to intercept dynamic URLs
      onGenerateRoute: (settings) {
        final Uri uri = Uri.parse(settings.name ?? "/");
        final args = settings.arguments as Map<String, dynamic>? ?? {};

        print("🚦 Routing to: ${uri.path}");

        // 1. Handle Products (e.g., /product/123)
        if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'product') {
           final String productId = uri.pathSegments.length > 1 ? uri.pathSegments[1] : '0';
           
           return MaterialPageRoute(
             builder: (_) => SDUIGenericPage(
               endpoint: "product/$productId", 
               initialData: args
             )
           );
        }

        // 2. Default: Home Page
        return MaterialPageRoute(
          builder: (_) => const SDUIGenericPage(endpoint: "home")
        );
      },
    );
  }
}