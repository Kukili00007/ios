class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final ratingData = json['rating'] as Map<String, dynamic>? ?? {};
    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'No title',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? 'No description',
      category: json['category'] as String? ?? 'General',
      imageUrl: json['image'] as String? ?? '',
      rating: (ratingData['rate'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (ratingData['count'] as num?)?.toInt() ?? 0,
    );
  }

  List<String> get galleryImages => [imageUrl, imageUrl, imageUrl];
  String get deepLink => 'narxoz://store/product/$id';
}
