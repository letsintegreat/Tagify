class UserModel {
  String id;
  String name;
  String email;
  List<String> tags = [];
  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  Map<String, String> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "tags": tags.join(","),
    };
  }

  static UserModel fromJson(Map<String, dynamic> data) {
    UserModel user = UserModel(id: data['id'], name: data['name'], email: data['email']);
    user.tags = data['tags'].split(",");
    return user;
  }

}