import 'package:bible/database.dart';
import 'package:flutter/material.dart';

class Note extends StatefulWidget {
  Note({
    @required this.passage,
    @required this.verse,
  });

  String passage;
  String verse;

  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  TextEditingController _content = new TextEditingController();

  bool _noteExists = false;

  _checkIfNoteExists(String passage) async {
    List note = await NotesDatabaseService.db.getNoteFromDB(passage);
    if (note.isNotEmpty) {
      _content.text = note[0]['content'];
      _noteExists = true;
    }
  }

  void initState() {
    super.initState();
    NotesDatabaseService.db.init();
    _checkIfNoteExists(widget.passage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Note',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Color(0XFF595959),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.passage,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${widget.verse}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                  fontFamily: 'Regular',
                  color: Color(0XFF000000),
                ),
                controller: _content,
                maxLines: 10,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'What would you like to say?',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    fontFamily: 'Regular',
                    color: Color(0xFFAAAAAA),
                  ),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0XFFAAAAAA),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0XFFAAAAAA),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0XFFAAAAAA),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0XFFE5B60F),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    fontFamily: 'Circular Std Book',
                    color: Color(0xFFFFFFFF).withOpacity(0.24),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                Map<String, dynamic> note = {
                  'passage': widget.passage,
                  'verse': widget.verse,
                  'content': _content.text,
                };
                print(note);
                if (_noteExists) {
                  NotesDatabaseService.db.updateNoteInDB(note);
                } else {
                  NotesDatabaseService.db.addNoteInDB(note);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  padding: EdgeInsets.fromLTRB(31, 0, 26, 0),
                  decoration: BoxDecoration(
                    color: Color(0XFFE5B60F),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                        fontSize: 20,
                        fontFamily: 'Bold',
                        color: Color(0xFF6E1F45),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 35,
            ),
          ],
        ),
      ),
    );
  }
}
