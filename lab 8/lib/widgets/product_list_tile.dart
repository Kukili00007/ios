import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductListTile extends StatelessWidget {
  final Product product;

  const ProductListTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(
        backgroundColor: product.color.withValues(alpha: 0.15),
        child: Icon(product.icon, color: product.color),
      ),
      title: Text(
        product.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('${product.category}  •  ⭐ ${product.rating}'),
      trailing: Text(
        '\$${product.price.toStringAsFixed(2)}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
