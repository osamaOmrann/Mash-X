class Job {
  static const String collectionName = 'jobs';
  String? id,
      companyName,
      companyImage,
      jobTitle,
      period,
      city,
      st_name,
      lat,
      lng;

  Job(
      {this.id,
      this.companyName,
      this.companyImage,
      this.jobTitle,
      this.period,
      this.city,
      this.st_name,
      this.lat,
      this.lng});

  Job.fromFireStore(Map<String, dynamic> data)
      : this(
            id: data['id'],
            companyName: data['company_name'],
            companyImage: data['company_image'],
            jobTitle: data['job_title'],
            period: data['period'],
            city: data['city'],
            st_name: data['st_name'],
            lat: data['lat'],
            lng: data['lng']);

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'company_name': companyName,
      'company_image': companyImage,
      'job_title': jobTitle,
      'period': period,
      'city': city,
      'st_name': st_name,
      'lat': lat,
      'lng': lng
    };
  }
}
