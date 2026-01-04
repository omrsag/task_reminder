class UserData {
  int id;
  String name;
  String email;

  UserData({required this.id, required this.name, required this.email});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: int.parse(json["id"].toString()),
      name: json["name"].toString(),
      email: json["email"].toString(),
    );
  }
}
