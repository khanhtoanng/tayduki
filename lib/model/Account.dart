class Account {
  final String username;
  final String password;
  final String phone;
  final String email;
  final String fullname;
  final String role;
  final int isActive;
  final String descriptionAccount;
  final String image;
  final String createTime;
  final String updateTime;
  final String updateAccount;

  Account(
      {this.username,
      this.password,
      this.phone,
      this.email,
      this.fullname,
      this.role,
      this.isActive,
      this.descriptionAccount,
      this.image,
      this.createTime,
      this.updateTime,
      this.updateAccount});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
        username: json['username'] as String,
        password: json['password'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
        fullname: json['fullname'] as String,
        role: json['role'] as String,
        isActive: json['isActive'] as int,
        descriptionAccount: json['descriptionAccount'] as String,
        image: json['image'] as String,
        createTime: json['createTime'] as String,
        updateTime: json['updateTime'] as String,
        updateAccount: json['updateAccount'] as String);
  }
}
