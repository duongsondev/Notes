import 'package:fa_notes/commom/database.dart';
import 'package:fa_notes/commom/type_color.dart';
import 'package:fa_notes/model/notes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailNotesPage extends StatefulWidget {
  Notes notes;

  DetailNotesPage(this.notes);

  @override
  _DetailNotesPageState createState() => _DetailNotesPageState();
}

class _DetailNotesPageState extends State<DetailNotesPage> {
  String title;
  bool add;
  TextEditingController _ctrlTitle, _ctrlContent;
  var _keyScaffold = GlobalKey<ScaffoldState>();
  int typeNotes = 0;
  int dropValue = 0;

  @override
  void initState() {
    _ctrlTitle = TextEditingController();
    _ctrlContent = TextEditingController();
    if (widget.notes == null) {
      title = "Add Notes";
      add = true;
    } else {
      title = "Detail";
      add = false;
      _ctrlTitle.text = widget.notes.title;
      _ctrlContent.text = widget.notes.content;
      dropValue = widget.notes.type;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyScaffold,
      appBar: AppBar(
        title: Text(title),
        actions: [
          FlatButton(
            child: Text(
              "Save",
              style: GoogleFonts.aBeeZee(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () => _fncAction(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FractionallySizedBox(
              widthFactor: 1.0,
              child: DropdownButton<int>(
                value: dropValue,
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                    value: 0,
                    child: Text(
                      "Normal",
                      style: TextStyle(color: ColorType.color[0]),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text("Necessary",
                        style: TextStyle(color: ColorType.color[1])),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text("Important",
                        style: TextStyle(color: ColorType.color[2])),
                  )
                ],
                onChanged: (value) {
                  dropValue = value;
                  setState(() {});
                },
              ),
            ),
            TextFormField(
              controller: _ctrlTitle,
              decoration: InputDecoration(
                  labelText: "Title",
                  hintText: "Enter title notes",
                  border: InputBorder.none),
              style: GoogleFonts.lato(fontWeight: FontWeight.bold),
            ),
            Divider(),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 1,
              controller: _ctrlContent,
              decoration: InputDecoration(
                  labelText: "Content",
                  hintText: "Enter Content notes",
                  border: InputBorder.none),
            ),
          ],
        ),
      ),
    );
  }

  void _fncAction() {
    String titleNotes = _ctrlTitle.text.trim();
    String contentNotes = _ctrlContent.text.trim();
    if (titleNotes.isEmpty && contentNotes.isEmpty) {
      _keyScaffold.currentState
          .showSnackBar(SnackBar(content: Text("Notes empty!")));
    } else {
      if (add) {
        Notes notes = Notes(0, titleNotes, contentNotes, dropValue,
            DateTime.now(), DateTime.now(), 1);
        DatabaseApp.insertNotes(notes);
        Navigator.pop(context);
      } else {
        Notes notes = Notes(widget.notes.id, titleNotes, contentNotes, dropValue,
            widget.notes.dateCreated, DateTime.now(), 1);
        DatabaseApp.updateNotes(notes);
        Navigator.pop(context);
      }
    }
  }
}
