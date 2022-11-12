import 'package:hackathon_project/models/message_model.dart';
import 'package:hackathon_project/models/user_model.dart';

class GroupModel {
  String name;
  String logic;
  List<MessageModel> messages=[];
  List<String> users=[];
  GroupModel({
    required this.name,
    required this.logic,
  });
  Map<String, dynamic> toJson () {
    return {
      'name': name,
      'logic': logic,
      'messages': messages.map((e) => e.toJson()).toList(),
      'users': users.join(","),
    };
  }
  static GroupModel fromJson (Map<String, dynamic> data) {
    GroupModel newGroup = GroupModel(name: data['name'], logic: data['logic']);
    data['messages'].forEach((e) {
      newGroup.messages.add(MessageModel.fromJson(e));
    });
    newGroup.users = data['users'].split(",");
    return newGroup;
  }
}