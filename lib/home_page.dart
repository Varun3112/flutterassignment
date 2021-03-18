import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterassignment/drawing_page.dart';
import 'package:flutterassignment/mynote.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MyNote> notes = <MyNote>[];
  List<MyNote> newnotes = <MyNote>[];

  SharedPreferences sharedPreferences;

  void initState() {
    initSharedPreferences();
    super.initState();
  }

  initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  TextEditingController textController = TextEditingController();
  TextEditingController textController2 = TextEditingController();

  void addNewNoteToList(String title) {
    setState(() {
      //notes.add(MyNote(title));
      newnotes.add(MyNote(title));
    });
    saveData();
  }

  void filterList(String search) {
    setState(() {
      if (search != null) {
        newnotes = notes.where((i) => i.title.contains(search)).toList();
      } else {
        newnotes = notes.toList();
      }
    });
  }

  void saveData() {
    List<String> spNotes =
        notes.map((note) => json.encode(note.toMap())).toList();
    sharedPreferences.setStringList('notes', spNotes);
  }

  void loadData() {
    List<String> spNotes = sharedPreferences.getStringList('notes');
    notes =
        spNotes?.map((note) => MyNote.fromMap(json.decode(note)))?.toList() ??
            [];
    newnotes = notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drawing Notes App"),
      ),
      body: Column(
        children: <Widget>[
          ListView(shrinkWrap: true, children: <Widget>[
            TextField(
              decoration: new InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: "Search for a Note"),
              controller: textController,
              onChanged: (String newText) {
                filterList(newText);
              },
            )
          ]),
          ListView.builder(
            shrinkWrap: true,
            itemCount: newnotes.length,
            itemBuilder: (context, index) {
              return Dismissible(
                  key: Key(newnotes[index].title),
                  onDismissed: (direction) {
                    // Remove the item from the data source.
                    setState(() {});
                    newnotes.removeAt(index);
                    notes.removeAt(index);
                    saveData();

                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Deleted")));
                  },
                  background: Container(color: Colors.red),
                  child: InkWell(
                    onTap: () {
                      saveData();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DrawingPage(note: newnotes[index])));
                    },
                    child: ListTile(title: Text(newnotes[index].title)),
                  ));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add",
        child: Icon(Icons.add),
        onPressed: () {
          return showDialog<void>(
            context: context,
            barrierDismissible: true, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add New Note'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      TextField(
                        controller: textController2,
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Add'),
                    onPressed: () {
                      addNewNoteToList(textController2.text);
                      textController2.text = "";
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
