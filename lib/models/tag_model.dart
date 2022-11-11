class TagModel {
  bool public;
  String name;
  TagModel({
    required this.public,
    required this.name,
  });
  Map<String, dynamic> toJson() {
    return {
      'public': public,
      'name': name,
    };
  }
  static TagModel fromJson(Map<String, dynamic> data) {
    return TagModel(public: data['public'], name: data['name']);
  }
}