class MessageModel {
  String name;
  String id;
  String text;
  String timeStamp;
  MessageModel({
    required this.name,
    required this.id,
    required this.text,
    required this.timeStamp,
  });
  Map<String, String> toJson() {
    return {
      'name': name,
      'id': id,
      'text': text,
      'timeStamp': timeStamp,
    };
  }
  static MessageModel fromJson(Map<String, dynamic> data) {
    return MessageModel(name: data['name'], id: data['id'], text: data['text'], timeStamp: data['timeStamp']);
  }
}