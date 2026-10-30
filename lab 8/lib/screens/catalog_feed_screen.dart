import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/product_grid_card.dart';
import '../widgets/product_list_tile.dart';

class CatalogFeedScreen extends StatefulWidget {
  const CatalogFeedScreen({super.key});

  @override
  State<CatalogFeedScreen> createState() => _CatalogFeedScreenState();
}

class _CatalogFeedScreenState extends State<CatalogFeedScreen> {
  bool showGrid = false;
  int nextId = 11;

  final List<Product> products = List.generate(10, (index) {
    const titles = [
      'Running Shoes',
      'Wireless Headphones',
      'Smart Watch',
      'Travel Backpack',
      'Coffee Maker',
      'Desk Lamp',
      'Water Bottle',
      'Phone Stand',
      'Sports Cap',
      'Laptop Sleeve',
    ];
    const categories = [
      'Sports',
      'Electronics',
      'Accessories',
      'Travel',
      'Kitchen',
      'Home',
      'Sports',
      'Accessories',
      'Clothing',
      'Electronics',
    ];
    const icons = [
      Icons.directions_run,
      Icons.headphones,
      Icons.watch,
      Icons.backpack,
      Icons.coffee,
      Icons.light,
      Icons.water_drop,
      Icons.phone_android,
      Icons.sports_baseball,
      Icons.laptop,
    ];
    const colors = [
      Colors.blue,
      Colors.deepPurple,
      Colors.teal,
      Colors.orange,
      Colors.brown,
      Colors.amber,
      Colors.cyan,
      Colors.indigo,
      Colors.red,
      Colors.green,
    ];

    return Product(
      id: '${index + 1}',
      title: titles[index],
      category: categories[index],
      price: 15.0 + index * 7.5,
      rating: 4.0 + (index % 10) / 10,
      icon: icons[index],
      color: colors[index],
    );
  });

  List<Product> get initialProducts => List.generate(10, (index) {
    const titles = [
      'Running Shoes',
      'Wireless Headphones',
      'Smart Watch',
      'Travel Backpack',
      'Coffee Maker',
      'Desk Lamp',
      'Water Bottle',
      'Phone Stand',
      'Sports Cap',
      'Laptop Sleeve',
    ];
    const categories = [
      'Sports',
      'Electronics',
      'Accessories',
      'Travel',
      'Kitchen',
      'Home',
      'Sports',
      'Accessories',
      'Clothing',
      'Electronics',
    ];
    const icons = [
      Icons.directions_run,
      Icons.headphones,
      Icons.watch,
      Icons.backpack,
      Icons.coffee,
      Icons.light,
      Icons.water_drop,
      Icons.phone_android,
      Icons.sports_baseball,
      Icons.laptop,
    ];
    const colors = [
      Colors.blue,
      Colors.deepPurple,
      Colors.teal,
      Colors.orange,
      Colors.brown,
      Colors.amber,
      Colors.cyan,
      Colors.indigo,
      Colors.red,
      Colors.green,
    ];

    return Product(
      id: '${index + 1}',
      title: titles[index],
      category: categories[index],
      price: 15.0 + index * 7.5,
      rating: 4.0 + (index % 10) / 10,
      icon: icons[index],
      color: colors[index],
    );
  });

  Future<void> refreshCatalog() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      products.insert(
        0,
        Product(
          id: '$nextId',
          title: 'New Product $nextId',
          category: 'New',
          price: 29.99,
          rating: 4.8,
          icon: Icons.new_releases,
          color: Colors.pink,
        ),
      );
      nextId++;
    });
  }

  void deleteProduct(Product product, int index) {
    setState(() {
      products.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              products.insert(index.clamp(0, products.length), product);
            });
          },
        ),
      ),
    );
  }

  Widget dismissibleProduct(
    Product product,
    int index, {
    required Widget child,
  }) {
    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => deleteProduct(product, index),
      child: child,
    );
  }

  Widget buildCatalog() {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            const Text('Catalog is Empty', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  products.addAll(initialProducts);
                });
              },
              child: const Text('Reset Catalog'),
            ),
          ],
        ),
      );
    }

    if (showGrid) {
      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return dismissibleProduct(
            product,
            index,
            child: ProductGridCard(product: product),
          );
        },
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: products.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final product = products[index];
        return dismissibleProduct(
          product,
          index,
          child: ProductListTile(product: product),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Catalog'),
        actions: [
          IconButton(
            tooltip: showGrid ? 'List view' : 'Grid view',
            onPressed: () => setState(() => showGrid = !showGrid),
            icon: Icon(showGrid ? Icons.view_list : Icons.grid_view),
          ),
        ],
      ),
      body: RefreshIndicator(onRefresh: refreshCatalog, child: buildCatalog()),
    );
  }
}
