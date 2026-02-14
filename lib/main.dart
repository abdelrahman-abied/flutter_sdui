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
      initialRoute: '/login',

      // We use onGenerateRoute to intercept dynamic URLs
      onGenerateRoute: (settings) {
        final Uri uri = Uri.parse(settings.name ?? "/");
        final args = settings.arguments as Map<String, dynamic>? ?? {};

        print("🚦 Routing to: ${uri.path}");

        // 1. Login Page
        if (uri.path == '/login' || uri.path == '/') {
          return MaterialPageRoute(
            builder: (_) => const SDUIGenericPage(endpoint: "login"),
          );
        }

        // 2. Products List
        if (uri.path == '/products') {
          return MaterialPageRoute(
            builder: (_) => const SDUIGenericPage(endpoint: "products"),
          );
        }

        // 3. Handle Product Details (e.g., /product/123)
        if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'product') {
          final String productId = uri.pathSegments.length > 1 ? uri.pathSegments[1] : '0';
          return MaterialPageRoute(
            builder: (_) => SDUIGenericPage(
              endpoint: "product/$productId",
              initialData: args,
            ),
          );
        }

        // 4. Home Page
        return MaterialPageRoute(
          builder: (_) => const SDUIGenericPage(endpoint: "home"),
        );
      },
    );
  }
}