class RoleActor {
  String username;
  String fullname;
  int idDestiny;
  String destinyName;
  String roleInDestiny;

  RoleActor(
      {this.fullname,
      this.destinyName,
      this.username,
      this.idDestiny,
      this.roleInDestiny});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'idDestiny': idDestiny,
      'roleInDestiny': roleInDestiny
    };
  }
}
