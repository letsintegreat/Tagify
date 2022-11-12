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
        content: Text(name + " has been created"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(229, 224, 239, 1),
        child: Column(
          children: [
            const SizedBox(
              height: 250,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: TextField(
                controller: _nameController,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'Enter the name',
                  hintStyle: GoogleFonts.poppins(
                    color: const Color.fromRGBO(140, 142, 151, 1),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey, width: 1)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey, width: 1)),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
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
                                : Color.fromRGBO(173, 149, 232, 0.9),
                          ),

                          
                          height: 56.0,
                          child: Center(child:  Text("Public",style: GoogleFonts.inter(fontSize: 18,fontWeight: FontWeight.w600),)),
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: (_isPublic)
                              ? Colors.white
                              : Color.fromRGBO(173, 149, 232, 0.9),),
                          
                          height: 56.0,
                          child: Center(child:  Text("Private",style: GoogleFonts.inter(fontSize: 18,fontWeight: FontWeight.w600),)),
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
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          backgroundColor: Color.fromRGBO(122, 83, 217, 0.9),
          onPressed: () => submit(context),
          child: const Icon(Icons.check),
        );
      }),
    );
  }
}
