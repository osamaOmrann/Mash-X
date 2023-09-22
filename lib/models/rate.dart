class Rate {
  static const String collectionName = 'rates';
  String? id, comment, name, image;
  int? rateValue;
  DateTime? dateTime;

  Rate(
      {this.id,
        this.comment,
        this.rateValue,
        this.name,
        this.image,
        this.dateTime});

  Rate.fromFireStore(Map<String, dynamic> data)
      : this(
      id: data['id'],
      comment: data['comment'],
      rateValue: data['rateValue'],
      name: data['name'],
      image: data['image'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(data['dateTime']),
      );

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'comment': comment,
      'rateValue': rateValue,
      'dateTime': dateTime?.millisecondsSinceEpoch,
      'name': name,
      'image': image
    };
  }
}
