import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LogicScreen extends StatefulWidget {
  const LogicScreen({super.key});

  @override
  State<LogicScreen> createState() => _LogicScreen();
}

class _LogicScreen extends State<LogicScreen> {
  List<String> availableTags = [];

  List<List<String>> buckets = [[]];

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
          return ListView.builder(
            itemCount: buckets.length,
            itemBuilder: (context, i) {
              TextEditingController text = TextEditingController();
              return Card(
                child: Column(children: [
                  Text("Bucket - ${i + 1}"),
                  Text(buckets[i].join("\n")),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: text,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String name = text.text;
                          if (name.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Tag can't be empty"),
                              ),
                            );
                            return;
                          }
                          name = name.toLowerCase();
                          if (!availableTags.contains(name)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("$name tag doesn't exist."),
                              ),
                            );
                            return;
                          }
                          if (buckets[i].contains(name)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("$name already exists."),
                              ),
                            );
                            return;
                          }
                          setState(() {
                            buckets[i].add(text.text);
                          });
                        },
                        child: const Text("Add"),
                      ),
                    ],
                  )
                ]),
              );
            },
          );
        },
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          onPressed: () {
            String logic = "(" + buckets[0].join("&") + ")";
            for (var i = 1; i < buckets.length; i++) {
              if (buckets[i].isEmpty) continue;
              logic = logic + "|";
              logic = logic + "(" + buckets[i].join("&") + ")";
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
