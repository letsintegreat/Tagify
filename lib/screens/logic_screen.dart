import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon_project/widgets/tags.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LogicScreen extends StatefulWidget {
  const LogicScreen({super.key});

  @override
  State<LogicScreen> createState() => _LogicScreen();
}

class _LogicScreen extends State<LogicScreen> {
  List<String> availableTags = [];

  List<List<String>> buckets = [[]];
  List data = [
    {"color": const Color(0xffff6968)},
    {"color": const Color(0xff7a54ff)},
    {"color": const Color(0xffff8f61)},
    {"color": const Color(0xff2ac3ff)},
    {"color": const Color(0xff5a65ff)},
    {"color": const Color(0xff96da45)},
    {"color": const Color(0xffff6968)},
    {"color": const Color(0xff7a54ff)},
    {"color": const Color(0xffff8f61)},
    {"color": const Color(0xff2ac3ff)},
    {"color": const Color(0xff5a65ff)},
    {"color": const Color(0xff96da45)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your logic'),
        backgroundColor: const Color(0xff7A53D9),
        elevation: 10,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              List<List<String>> newList = buckets;
              newList.add([]);
              setState(() {
                buckets = newList;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("tags").get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          for (var ind = 0; ind < snapshot.data!.docs.length; ind++) {
            availableTags.add(snapshot.data!.docs[ind].id);
          }
          return Container(
            color: const Color.fromRGBO(229, 224, 239, 1),
            padding: const EdgeInsets.only(top: 10),
            child: MasonryGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              itemCount: buckets.length,
              itemBuilder: (context, i) {
                TextEditingController text = TextEditingController();
                return Card(
                  color: data[1]["color"],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 10,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Bucket ${i + 1}",
                            style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),

                        Container(
                          constraints: const BoxConstraints(minHeight: 40, minWidth: 100),
                          width: 100,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(82, 45, 174, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(36))),
                          child: Center(
                            child: Column(
                              children: [
                                for (var j = 0; j != buckets[i].length; j++)
                                  Text(
                                    buckets[i][j],
                                    style: GoogleFonts.inter(
                                        color: Colors.white, fontSize: 12),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        // Text(buckets[i].join("\n"),
                        //     style: GoogleFonts.inter(
                        //         fontSize: 20,
                        //         fontWeight: FontWeight.w500,
                        //         color: Colors.white)),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromRGBO(76, 49, 159, 1))),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return GestureDetector(
                                      onTap: () {},
                                      behavior: HitTestBehavior.opaque,
                                      // this ensures nothing is done onTap on the modal
                                      child: Container(
                                        color: const Color.fromRGBO(
                                            229, 224, 239, 1),
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                          right: 5,
                                          left: 5,
                                        ),
                                        child: Card(
                                          color: const Color.fromRGBO(
                                              229, 224, 239, 1),
                                          elevation: 10,
                                          child: SingleChildScrollView(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                top: 10,
                                                bottom: MediaQuery.of(context)
                                                        .viewInsets
                                                        .bottom +
                                                    100,
                                                right: 10,
                                                left: 10,
                                              ),
                                              child: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Autocomplete<String>(
                                                    optionsMaxHeight: 100,
                                                    optionsBuilder: (TextEditingValue textEditingValue) {
                                                      if (textEditingValue.text == '') {
                                                        return const Iterable<String>.empty();
                                                      }
                                                      return availableTags.where((String option) {
                                                        return option.contains(textEditingValue.text.toLowerCase());
                                                      });
                                                    },
                                                    optionsViewBuilder: (context, onSelected, options){
                                                      return Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Material(
                                                            color: const Color.fromRGBO(229, 224, 239, 1),
                                                            elevation: 4.0,

                                                            child: Container(
                                                                width: MediaQuery.of(context).size.width - 40,
                                                                height: 100,
                                                                child: ListView.separated(
                                                                  padding: EdgeInsets.zero,
                                                                  itemBuilder: (context, index){
                                                                    final option = options.elementAt(index);
                                                                    return ListTile(
                                                                      title: Text(
                                                                        option,
                                                                        style: GoogleFonts.inter(
                                                                            fontSize: 12,
                                                                            fontWeight:
                                                                            FontWeight.w600,
                                                                            color: const Color
                                                                                .fromRGBO(
                                                                                82, 45, 174, 1)),
                                                                      ),
                                                                      onTap: (){onSelected(option.toString());},
                                                                    );
                                                                  },
                                                                  itemCount: options.length,
                                                                  separatorBuilder: (BuildContext context, int index) {return const Divider(height: 0,);  },
                                                                ),
                                                            ),
                                                          )
                                                      );
                                                    },
                                                    fieldViewBuilder: (context, text1, focusNode, onFieldSubmitted){
                                                      text=text1;
                                                      return TextField(
                                                            controller: text1,
                                                            focusNode: focusNode,
                                                            onEditingComplete: onFieldSubmitted,

                                                            cursorColor:
                                                                const Color.fromRGBO(
                                                                    82, 45, 174, 1),
                                                            autofocus: true,
                                                            style: GoogleFonts.inter(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight.w600,
                                                                color: const Color
                                                                        .fromRGBO(
                                                                    82, 45, 174, 1)),
                                                            decoration: InputDecoration(
                                                              hintText: 'Enter a tag',
                                                              hintStyle:
                                                                  GoogleFonts.poppins(
                                                                color: const Color
                                                                        .fromRGBO(
                                                                    82, 45, 174, 1),
                                                                fontWeight:
                                                                    FontWeight.w500,
                                                                fontSize: 14,
                                                              ),
                                                              border: const OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              8)),
                                                                  borderSide: BorderSide(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              82,
                                                                              45,
                                                                              174,
                                                                              1),
                                                                      width: 2)),
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              8)),
                                                                  borderSide: BorderSide(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              82,
                                                                              45,
                                                                              174,
                                                                              1),
                                                                      width: 2)),
                                                            ),
                                                          );
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(const Color
                                                                            .fromRGBO(
                                                                        76,
                                                                        49,
                                                                        159,
                                                                        1))),
                                                        onPressed: () {
                                                          String name =
                                                              text.text;
                                                          if (name.isEmpty) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    "Tag can't be empty"),
                                                              ),
                                                            );
                                                            return;
                                                          }
                                                          name = name
                                                              .toLowerCase();
                                                          if (!availableTags
                                                              .contains(name)) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    "$name tag doesn't exist."),
                                                              ),
                                                            );
                                                            return;
                                                          }
                                                          if (buckets[i]
                                                              .contains(name)) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    "$name already exists."),
                                                              ),
                                                            );
                                                            return;
                                                          }
                                                          setState(() {
                                                            buckets[i]
                                                                .add(text.text);
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Add ',
                                                          style:
                                                              GoogleFonts.inter(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: const Text('Add Tag')),
                        const SizedBox(
                          height: 8.0,
                        )
                      ]),
                );
              },
            ),
          );
        },
      ),
      //hi
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          backgroundColor: const Color.fromRGBO(122, 83, 217, 0.9),
          onPressed: () {
            String logic = "(${buckets[0].join("&")})";
            for (var i = 1; i < buckets.length; i++) {
              if (buckets[i].isEmpty) continue;
              logic = "$logic|";
              logic = "$logic(${buckets[i].join("&")})";
            }
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop(logic);
            });
          },
          child: const Icon(Icons.check),
        );
      }),
    );
  }
}
