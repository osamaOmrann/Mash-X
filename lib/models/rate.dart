class Rate {
  static const String collectionName = 'rates';
  String? id, comment, ratedUserId, companyName;
  int? rateValue;
  DateTime? dateTime;

  Rate(
      {this.id,
        this.comment,
        this.ratedUserId,
        this.rateValue,
        this.dateTime, this.companyName});

  Rate.fromFireStore(Map<String, dynamic> data)
      : this(
      id: data['id'],
      comment: data['comment'],
      ratedUserId: data['ratedUserId'],
      rateValue: data['rateValue'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(data['dateTime']),
      companyName: data['companyName']);

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'comment': comment,
      'ratedUserId': ratedUserId,
      'rateValue': rateValue,
      'dateTime': dateTime?.millisecondsSinceEpoch,
      'companyName': companyName
    };
  }
}
