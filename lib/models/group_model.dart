import 'package:hackathon_project/models/message_model.dart';
import 'package:hackathon_project/models/user_model.dart';

class GroupModel {
  String name;
  String logic;
  String groupId;
  List<MessageModel> messages = [];
  List<String> users = [];
  GroupModel({
    required this.name,
    required this.logic,
    required this.groupId,
  });
  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'name': name,
      'logic': logic,
      'messages': messages.map((e) => e.toJson()).toList(),
      'users': users.join(","),
    };
  }

  static GroupModel fromJson(Map<String, dynamic> data) {
    GroupModel newGroup = GroupModel(groupId: data['groupId'],name: data['name'], logic: data['logic']);
    data['messages'].forEach((e) {
      newGroup.messages.add(MessageModel.fromJson(e));
    });
    newGroup.users = data['users'].split(",");
    return newGroup;
  }
}
