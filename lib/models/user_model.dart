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

  bool evaluateLogic(String logic) {
    List<String> logics = logic.split("|");
    for (var i = 0; i < logics.length; i++) {
      List<String> reqTags = logics[i].split("(")[1].split(")")[0].split("&");
      int count = 0;
      for (var j = 0; j < reqTags.length; j++) {
        if (tags.contains(reqTags[j])) count++;
      }
      if (count == reqTags.length) {
        return true;
      }
    }
    return false;
  }

}