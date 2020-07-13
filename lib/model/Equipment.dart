class Equipment {
  final int id;
  final String name;
  final String description;
  final int quantity;
  final String image;
  final String status;

  Equipment(
      {this.id,
      this.name,
      this.description,
      this.quantity,
      this.image,
      this.status});

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String,
        quantity: json['quantity'] as int,
        image: json['image'] as String,
        status: json['status'] as String);
  }
}
