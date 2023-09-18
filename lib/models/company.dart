class Company {
  static const String collectionName = 'companies';
  String? id, name, image;
  List? employees;

  Company({this.id, this.name, this.image, this.employees});

  Company.fromFireStore(Map<String, dynamic> data)
      : this(id: data['id'], name: data['name'], image: data['image'], employees: data['employees']);

  Map<String, dynamic> toFireStore() {
    return {'id': id, 'name': name, 'image': image, 'employees': employees};
  }
}
