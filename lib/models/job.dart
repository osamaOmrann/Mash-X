class Job {
  static const String collectionName = 'jobs';
  String? id, companyName, companyImage, jobTitle;

  Job({this.id, this.companyName, this.companyImage, this.jobTitle});

  Job.fromFireStore(Map<String, dynamic> data)
      : this(id: data['id'], companyName: data['company_name'], companyImage: data['company_image'], jobTitle: data['job_title']);

  Map<String, dynamic> toFireStore() {
    return {'id': id, 'company_name': companyName, 'company_image': companyImage, 'job_title': jobTitle};
  }
}