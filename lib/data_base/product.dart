class Product {
  static const String collectionName = 'products';
  String? id,
      description,
      publisher_name,
      publisher_image,
      image;
  DateTime? date;
  int? price;
  double?  rate_percentage;
  bool? sold;

  Product(
      {this.id, this.image, this.date, this.description, this.price, this.publisher_image, this.publisher_name, this.rate_percentage, this.sold});

  Product.fromFirestore(Map<String, dynamic> data)
      : this(
      id: data['id'],
      image: data['image'],
      date: DateTime.fromMillisecondsSinceEpoch(data['date']),
    description: data['description'],
    price: data['price'],
    publisher_image: data['publisher_image'],
    publisher_name: data['publisher_name'],
    rate_percentage: data['rate_percentage'],
    sold: data['sold']
  );

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'image': image,
      'date': date?.millisecondsSinceEpoch,
      'description': description,
      'price': price,
      'publisher_image': publisher_image,
      'publisher_name': publisher_name,
      'rate_percentage': rate_percentage,
      'sold': sold
    };
  }
}