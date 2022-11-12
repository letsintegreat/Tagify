import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/models/tag_model.dart';

class NewTagScreen extends StatefulWidget {
  const NewTagScreen({super.key});

  @override
  State<NewTagScreen> createState() => _NewTagScreen();
}

class _NewTagScreen extends State<NewTagScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isPublic = true;
  static final  validCharacters = RegExp(r'^[a-zA-Z0-9_]+$');

  void submit(BuildContext context) async {
    String name = _nameController.text;
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Name can't be empty"),
        ),
      );
      return;
    }
    if (!validCharacters.hasMatch(name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Name has to be alphanumeric with underscores."),
        ),
      );
      return;
    }
    name = name.toLowerCase();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference tags = firestore.collection('tags');
    DocumentSnapshot snapshot = await tags.doc(name).get();
    if (snapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tag already exists"),
        ),
      );
      return;
    }
    TagModel newTag = TagModel(public: _isPublic, name: name);
    tags.doc(name).set(newTag.toJson());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(name + " has been created"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _nameController,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPublic = true;
                      });
                    },
                    child: Container(
                      color: (!_isPublic) ? Colors.white : Colors.green,
                      height: 56.0,
                      child: const Text("Public"),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPublic = false;
                      });
                    },
                    child: Container(
                      color: (_isPublic) ? Colors.white : Colors.green,
                      height: 56.0,
                      child: const Text("Private"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            onPressed: () => submit(context),
            child: const Icon(Icons.check),
          );
        }
      ),
    );
  }
}
