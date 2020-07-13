class Destiny {
  final int id;
  final String name;
  final String location;
  final String description;
  final String createTime;
  final String endTime;
  final String detail;
  final int numberOfScreen;

  Destiny(
      {this.id,
      this.name,
      this.location,
      this.description,
      this.createTime,
      this.endTime,
      this.detail,
      this.numberOfScreen});

  factory Destiny.fromJson(Map<String, dynamic> json) {
    return Destiny(
        id: json['id'] as int,
        name: json['name'] as String,
        location: json['location'] as String,
        description: json['description'] as String,
        createTime: json['createTime'] as String,
        endTime: json['endTime'] as String,
        detail: json['detail'] as String,
        numberOfScreen: json['numberOfScreen'] as int);
  }
}
