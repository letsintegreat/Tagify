import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/models/tag_model.dart';
import 'package:google_fonts/google_fonts.dart';

class NewTagScreen extends StatefulWidget {
  const NewTagScreen({super.key});

  @override
  State<NewTagScreen> createState() => _NewTagScreen();
}

class _NewTagScreen extends State<NewTagScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isPublic = true;
  static final validCharacters = RegExp(r'^[a-zA-Z0-9_]+$');

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
        content: Text("$name has been created"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(229, 224, 239, 1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: TextField(
                  controller: _nameController,
                  textAlign: TextAlign.start,
                  autofocus: true,
                  cursorColor: Color.fromRGBO(82, 45, 174, 1),
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(82, 45, 174, 1)),
                  decoration: InputDecoration(
                    hintText: 'Enter tag name',
                    hintStyle: GoogleFonts.poppins(
                      color: Color.fromRGBO(82, 45, 174, 1),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(82, 45, 174, 1), width: 2)),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(82, 45, 174, 1), width: 2)),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPublic = true;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: (!_isPublic)
                                  ? Colors.white
                                  : const Color.fromRGBO(173, 149, 232, 0.9),
                            ),
                            height: 56.0,
                            child: Center(
                              child: Text(
                                "Public",
                                style: GoogleFonts.inter(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPublic = false;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: (_isPublic)
                                  ? Colors.white
                                  : const Color.fromRGBO(173, 149, 232, 0.9),
                            ),
                            height: 56.0,
                            child: Center(
                              child: Text(
                                "Private",
                                style: GoogleFonts.inter(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          backgroundColor: const Color.fromRGBO(122, 83, 217, 0.9),
          onPressed: () => submit(context),
          child: const Icon(Icons.check),
        );
      }),
    );
  }
}
