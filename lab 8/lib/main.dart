import 'package:flutter/material.dart';

import 'screens/catalog_feed_screen.dart';

void main() {
  runApp(const NarxozStoreApp());
}

class NarxozStoreApp extends StatelessWidget {
  const NarxozStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const CatalogFeedScreen(),
    );
  }
}
