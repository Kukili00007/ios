abstract class MediaItem {
  String id;
  String title;
  double price;

  MediaItem(this.id, this.title, this.price);

  String getDetails();
}

mixin Downloadable {
  void download(String title) {
    print('Downloading $title...');
  }
}

class Audiobook extends MediaItem with Downloadable {
  double durationHours;
  String narrator;

  Audiobook(
    String id,
    String title,
    double price,
    this.durationHours,
    this.narrator,
  ) : super(id, title, price);

  @override
  String getDetails() {
    return 'Audiobook: $title | Narrator: $narrator | Duration: $durationHours hours | \$$price';
  }
}

class EBook extends MediaItem with Downloadable {
  double fileSizeMB;
  String author;

  EBook(
    String id,
    String title,
    double price,
    this.fileSizeMB,
    this.author,
  ) : super(id, title, price);

  @override
  String getDetails() {
    return 'EBook: $title | Author: $author | File size: $fileSizeMB MB | \$$price';
  }
}

class ShoppingCart {
  List<MediaItem> _items = [];

  void addItem(MediaItem item) {
    _items.add(item);
  }

  double calculateTotalWithTax({double taxRate = 0.12}) {
    double subtotal = _items.fold(0.0, (total, item) => total + item.price);
    return subtotal + (subtotal * taxRate);
  }

  List<MediaItem> filterByMaxPrice(double maxPrice) {
    return _items.where((item) => item.price <= maxPrice).toList();
  }

  void printReceipt() {
    print('----- RECEIPT -----');
    for (MediaItem item in _items) {
      print(item.getDetails());

      if (item is Downloadable) {
        (item as Downloadable).download(item.title);
      }
    }
    print('Total with 12% tax: \$${calculateTotalWithTax().toStringAsFixed(2)}');
  }
}

void main() {
  ShoppingCart cart = ShoppingCart();

  cart.addItem(Audiobook('A01', 'Atomic Habits', 14.99, 5.5, 'James Clear'));
  cart.addItem(EBook('E01', 'Flutter Basics', 9.50, 3.2, 'John Smith'));
  cart.addItem(Audiobook('A02', 'The Alchemist', 11.00, 4.0, 'Jeremy Irons'));

  print('Items with price less than or equal to \$12:');
  for (MediaItem item in cart.filterByMaxPrice(12.0)) {
    print(item.getDetails());
  }

  print('');
  cart.printReceipt();
}
