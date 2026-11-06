import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class Product {
  final String name;
  final double price;
  final IconData icon;

  const Product({required this.name, required this.price, required this.icon});
}

class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  final List<Product> products = const [
    Product(name: 'Canvas Backpack', price: 28.0, icon: Icons.backpack),
    Product(name: 'Desk Lamp', price: 19.5, icon: Icons.light),
    Product(name: 'Coffee Mug', price: 8.0, icon: Icons.coffee),
    Product(name: 'Wireless Mouse', price: 24.0, icon: Icons.mouse),
    Product(name: 'Notebook Set', price: 6.5, icon: Icons.menu_book),
    Product(name: 'Water Bottle', price: 12.0, icon: Icons.water_drop),
  ];

  List<Product> get items => List.unmodifiable(_items);
  int get count => _items.length;
  double get total => _items.fold(0, (sum, item) => sum + item.price);

  bool contains(Product product) => _items.contains(product);

  void toggle(Product product) {
    if (contains(product)) {
      _items.remove(product);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void remove(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const CatalogScreen(),
    );
  }
}

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Store'),
        actions: [
          IconButton(
            tooltip: 'Open cart',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            icon: Badge(
              isLabelVisible: cart.count > 0,
              label: Text('${cart.count}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: cart.products.length,
        itemBuilder: (context, index) {
          final product = cart.products[index];
          final added = cart.contains(product);

          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(product.icon)),
              title: Text(product.name),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              trailing: TextButton(
                onPressed: () => context.read<CartProvider>().toggle(product),
                child: Text(added ? 'Remove' : 'Add'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => context.read<CartProvider>().clear(),
              child: const Text('Clear All'),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: cart.items.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final product = cart.items[index];

                      return ListTile(
                        leading: CircleAvatar(child: Icon(product.icon)),
                        title: Text(product.name),
                        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          onPressed: () =>
                              context.read<CartProvider>().remove(product),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 18)),
                        Text(
                          '\$${cart.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
