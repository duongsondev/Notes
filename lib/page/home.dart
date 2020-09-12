import 'package:fa_notes/commom/database.dart';
import 'package:fa_notes/commom/type_color.dart';
import 'package:fa_notes/model/notes.dart';
import 'package:fa_notes/page/detail_notes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _title = "Notes";
  List<Notes> _lstNotes;
  bool bin = false;
  int type = -1;

  @override
  void initState() {
    DatabaseApp.getListNotes(1).then((value) {
      _lstNotes = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$_title"),
        backgroundColor: bin
            ? Colors.red[700]
            : type == -1
                ? Colors.blue
                : type == 0
                    ? Colors.green
                    : type == 1 ? Colors.orange : Colors.red,
      ),
      drawer: _drawer(),
      body: _lstNotes == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _lstNotes.length > 0
              ? ListView.builder(
                  itemCount: _lstNotes.length,
                  itemBuilder: (context, index) {
                    Notes notes = _lstNotes[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailNotesPage(notes))).whenComplete(() {
                          DatabaseApp.getListNotes(1).then((value) {
                            _lstNotes = value;
                            setState(() {});
                          });
                        });
                      },
                      child: Card(
                        child: Dismissible(
                          key: Key(notes.id.toString()),
                          child: _notesLayout(notes),
                          background: Container(
                            color: bin ? Colors.green : Colors.red,
                            child: _bgDissmissible(),
                            alignment: AlignmentDirectional.centerStart,
                          ),
                          secondaryBackground: Container(
                            color: bin ? Colors.green : Colors.red,
                            child: _bgDissmissible(),
                            alignment: AlignmentDirectional.centerEnd,
                          ),
                          onDismissed: (dd) {
                            DatabaseApp.setActive(notes.id, bin ? 1 : 0);
                            setState(() {
                              _lstNotes.removeAt(index);
                            });
                          },
                          confirmDismiss: bin
                              ? (dd) async => true
                              : (dd) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirm deletion?"),
                                        content: const Text(
                                            "Once deleted, the note will remain in the trash."),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text(
                                                "DELETE",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )),
                                          FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text("KEEP"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Press "),
                      Icon(
                        Icons.add,
                      ),
                      Text(" to create a new note.")
                    ],
                  ),
                ),
      floatingActionButton: _floatButton(),
    );
  }

  Widget _notesLayout(Notes notes) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.99,
        child: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorType.color[notes.type],
                      maxRadius: 6.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      notes.title.length < 100
                          ? notes.title
                          : notes.title.substring(0, 99) + "...",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(notes.content.length < 100
                      ? notes.content
                      : notes.content.substring(0, 99) + "..."),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.update,
                          size: 12.0,
                        ),
                        Text(
                          " ${notes.lastUpdated.day}/${notes.lastUpdated.month}/${notes.lastUpdated.year} ${notes.lastUpdated.hour}:${notes.lastUpdated.minute}",
                          style: TextStyle(
                              fontSize: 12.0, fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          size: 12.0,
                        ),
                        Text(
                          " ${notes.dateCreated.day}/${notes.dateCreated.month}/${notes.dateCreated.year} ${notes.dateCreated.hour}:${notes.dateCreated.minute}",
                          style: TextStyle(
                              fontSize: 12.0, fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bgDissmissible() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              bin ? Icons.undo : Icons.delete,
              color: Colors.white,
            ),
            Text(
              bin ? " Restore" : " Delete",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      );

  Widget _floatButton() => FloatingActionButton(
        backgroundColor: bin
            ? Colors.red[700]
            : type == -1
                ? Colors.blue
                : type == 0
                    ? Colors.green
                    : type == 1 ? Colors.orange : Colors.red,
        onPressed: () {
          if (bin) {
            _lstNotes.forEach((notes) => DatabaseApp.deleteNotes(notes.id));
            setState(() {
              _lstNotes.clear();
            });
          } else
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailNotesPage.add(type == -1 ? 0 : type)))
                .whenComplete(() {
              type == -1
                  ? DatabaseApp.getListNotes(1).then((value) {
                      _lstNotes = value;
                      setState(() {});
                    })
                  : DatabaseApp.getListNotesByType(type).then((value) {
                      _lstNotes = value;
                      setState(() {});
                    });
            });
        },
        child: bin ? Icon(Icons.clear_all) : Icon(Icons.add),
      );

  Widget _drawer() => Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  "Notes",
                  style: GoogleFonts.lato(fontSize: 28.0, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              title: Text("Recycle Bin"),
              leading: Icon(
                Icons.delete_forever,
                color: Colors.red[700],
              ),
              onTap: () async {
                _title = "Recycle Bin";
                bin = true;
                await DatabaseApp.getListNotes(0).then((value) {
                  _lstNotes = value;
                  setState(() {});
                });
                Navigator.pop(context);
              },
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Category",
                style: GoogleFonts.lato(fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            ListTile(
              title: Text("All"),
              leading: Icon(
                Icons.brightness_1,
                color: Colors.blue,
              ),
              onTap: () async {
                type = -1;
                _title = "Notes";
                bin = false;
                await DatabaseApp.getListNotes(1).then((value) {
                  _lstNotes = value;
                  setState(() {});
                });
                Navigator.pop(context);
              },
            ),
            _typeTap(0, "Normal"),
            _typeTap(1, "Necessary"),
            _typeTap(2, "Important"),
          ],
        ),
      );

  Widget _typeTap(int type, String title) => ListTile(
        title: Text("$title"),
        leading: Icon(
          Icons.brightness_1,
          color: ColorType.color[type],
        ),
        onTap: () async {
          this.type = type;
          _title = "Notes: $title";
          bin = false;
          await DatabaseApp.getListNotesByType(type).then((value) {
            _lstNotes = value;
            setState(() {});
          });
          Navigator.pop(context);
        },
      );
}
