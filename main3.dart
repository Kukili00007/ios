import 'package:flutter/material.dart';

void main() {
  runApp(const ShopApp());
}

class Product {
  final String title;
  final String description;
  final String image;
  final String price;
  final String category;

  const Product({
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.category,
  });
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final Set<String> favorites = {};

  final products = const [
    Product(
      title: 'Nike Air Max',
      description: 'Comfortable sneakers for everyday use.',
      image:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=700&q=80',
      price: '\$120',
      category: 'Sneakers',
    ),
    Product(
      title: 'Black Watch',
      description: 'Simple watch with a modern design.',
      image:
          'https://images.unsplash.com/photo-1524805444758-089113d48a6d?auto=format&fit=crop&w=700&q=80',
      price: '\$80',
      category: 'Accessories',
    ),
    Product(
      title: 'Wireless Headphones',
      description: 'Headphones for music and everyday listening.',
      image:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=700&q=80',
      price: '\$65',
      category: 'Electronics',
    ),
    Product(
      title: 'Blue Backpack',
      description: 'Backpack for university and travel.',
      image:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=700&q=80',
      price: '\$45',
      category: 'Bags',
    ),
  ];

  void toggleFavorite(Product product) {
    setState(() {
      if (favorites.contains(product.title)) {
        favorites.remove(product.title);
      } else {
        favorites.add(product.title);
      }
    });
  }

  void openDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          product: product,
          isFavorite: favorites.contains(product.title),
          onFavorite: () => toggleFavorite(product),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProducts = products
        .where((product) => favorites.contains(product.title))
        .toList();

    final pages = [
      ProductsList(
        products: products,
        favorites: favorites,
        onTap: openDetail,
        onFavorite: toggleFavorite,
      ),
      ProductsList(
        products: favoriteProducts,
        favorites: favorites,
        onTap: openDetail,
        onFavorite: toggleFavorite,
        emptyText: 'No favorite items yet',
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(['Feed', 'Favorites', 'Profile'][selectedIndex]),
        centerTitle: true,
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class ProductsList extends StatelessWidget {
  final List<Product> products;
  final Set<String> favorites;
  final ValueChanged<Product> onTap;
  final ValueChanged<Product> onFavorite;
  final String? emptyText;

  const ProductsList({
    super.key,
    required this.products,
    required this.favorites,
    required this.onTap,
    required this.onFavorite,
    this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(child: Text(emptyText ?? 'No products'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isFavorite = favorites.contains(product.title);

        return Card(
          child: ListTile(
            onTap: () => onTap(product),
            leading: ProductImage(image: product.image, size: 60),
            title: Text(product.title),
            subtitle: Text('${product.category} • ${product.price}'),
            trailing: IconButton(
              onPressed: () => onFavorite(product),
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProductImage extends StatelessWidget {
  final String image;
  final double size;

  const ProductImage({super.key, required this.image, required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        image,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(
            width: size,
            height: size,
            child: const Icon(Icons.image),
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 45, child: Icon(Icons.person, size: 50)),
          SizedBox(height: 12),
          Text('Kuka', style: TextStyle(fontSize: 22)),
          Text('Student', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavorite;

  const DetailScreen({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavorite,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  void toggleFavorite() {
    setState(() => isFavorite = !isFavorite);
    widget.onFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: toggleFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImage(image: product.image, size: 260),
            const SizedBox(height: 20),
            Text(
              product.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(product.category, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(
              product.price,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(product.description, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Feed'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
