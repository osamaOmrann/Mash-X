class MyUser {
  static const String collectionName = 'users';
  String? uid, name, email, image_url, password, city, st_name, postal_code;
  int? phone_number, building_number;
  DateTime? birth_date;
  List? rates;

  MyUser(
      {this.uid,
      this.name,
      this.email,
      this.image_url,
      this.password,
      this.phone_number,
      this.birth_date,
      this.city,
      this.st_name,
      this.building_number,
      this.postal_code, this.rates});

  MyUser.fromFireStore(Map<String, dynamic> data)
      : this(
            uid: data['uid'],
            name: data['name'],
            email: data['email'],
            image_url: data['image_url'],
            password: data['password'],
            phone_number: data['phone_number'],
            birth_date: DateTime.fromMillisecondsSinceEpoch(data['birth_date']),
            city: data['city'],
            st_name: data['st_name'],
            building_number: data['building_number'],
            postal_code: data['postal_code'],
  rates: data['rates']);

  Map<String, dynamic> toFireStore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'image_url': image_url,
      'password': password,
      'phone_number': phone_number,
      'birth_date': birth_date?.millisecondsSinceEpoch,
      'city': city,
      'st_name': st_name,
      'building_number': building_number,
      'postal_code': postal_code,
      'rates': rates
    };
  }
}
