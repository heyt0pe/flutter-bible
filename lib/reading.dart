import 'package:bible/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart';

class BibleReading extends StatefulWidget {
  BibleReading({
    @required this.testament,
    @required this.book,
    @required this.chapter,
    @required this.version,
  });

  int testament;
  int book;
  int chapter;
  String version;

  @override
  _BibleReadingState createState() => _BibleReadingState();
}

class _BibleReadingState extends State<BibleReading> {
  List versions = ['ESV', 'KJV', 'NIV', 'NLT'];

  List<String> verses = [];

  bool _bibleLoaded = false;

  getXmlDoc() async {
    print(widget.book);
    print(widget.chapter);
    final String file = await rootBundle.loadString(
      'assets/bibles/${widget.version}.xml',
    );
    final document = XmlDocument.parse(file);
    verses = [];
    print(document
        .findAllElements('testament')
        .elementAt(widget.testament)
        .findAllElements('book')
        .elementAt(widget.book)
        .findAllElements('chapter')
        .elementAt(widget.chapter)
        .findAllElements('verse')
        .map((verse) {
      verses.add(verse.text);
    }));
    setState(() {
      _bibleLoaded = true;
    });
  }

  void initState() {
    super.initState();
    getXmlDoc();
  }

  List<Widget> _getBibleVersions() {
    List<Widget> bibleVersions = [];
    for (String version in versions) {
      bibleVersions.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(version),
            Radio(
              value: version,
              groupValue: widget.version,
              onChanged: (value) {
                widget.version = value;
                setState(() {
                  _bibleLoaded = false;
                });
                getXmlDoc();
              },
            ),
          ],
        ),
      );
    }
    return bibleVersions;
  }

  Map _bibleStructure = {
    0: {
      "Genesis": 50,
      "Exodus": 40,
      "Leviticus": 27,
      "Numbers": 36,
      "Deuteronomy": 34,
      "Joshua": 24,
      "Judges": 21,
      "Ruth": 4,
      "1 Samuel": 31,
      "2 Samuel": 24,
      "1 Kings": 22,
      "2 Kings": 25,
      "1 Chronicles": 29,
      "2 Chronicles": 36,
      "Ezra": 10,
      "Nehemiah": 13,
      "Esther": 10,
      "Job": 42,
      "Psalms": 150,
      "Proverbs": 31,
      "Ecclesiastes": 12,
      "Song of Songs": 8,
      "Isaiah": 66,
      "Jeremiah": 52,
      "Lamentations": 5,
      "Ezekiel": 48,
      "Daniel": 12,
      "Hosea": 14,
      "Joel": 3,
      "Amos": 9,
      "Obadiah": 1,
      "Jonah": 4,
      "Micah": 7,
      "Nahum": 3,
      "Habakkuk": 3,
      "Zephaniah": 3,
      "Haggai": 2,
      "Zechariah": 14,
      "Malachi": 4
    },
    1: {
      "Matthew": 28,
      "Mark": 16,
      "Luke": 24,
      "John": 21,
      "Acts": 28,
      "Romans": 16,
      "1 Corinthians": 16,
      "2 Corinthians": 13,
      "Galatians": 6,
      "Ephesians": 6,
      "Philippians": 4,
      "Colossians": 4,
      "1 Thessalonians": 5,
      "2 Thessalonians": 3,
      "1 Timothy": 6,
      "2 Timothy": 4,
      "Titus": 3,
      "Philemon": 1,
      "Hebrews": 13,
      "James": 5,
      "1 Peter": 5,
      "2 Peter": 3,
      "1 John": 5,
      "2 John": 1,
      "3 John": 1,
      "Jude": 1,
      "Revelation": 22
    }
  };

  void _next() {
    if ((widget.chapter + 1) <
        _bibleStructure[widget.testament].values.elementAt(widget.book)) {
      setState(() {
        widget.chapter += 1;
        _bibleLoaded = false;
      });
      getXmlDoc();
    } else if (widget.testament == 1) {
      if (widget.book < 26) {
        setState(() {
          widget.book += 1;
          widget.chapter = 0;
          _bibleLoaded = false;
        });
        getXmlDoc();
      }
    } else if (widget.testament == 0) {
      if (widget.book < 39) {
        setState(() {
          widget.book += 1;
          widget.chapter = 0;
          _bibleLoaded = false;
        });
        getXmlDoc();
      }
      if (widget.book == 39) {
        setState(() {
          widget.testament = 1;
          widget.book = 0;
          widget.chapter = 0;
          _bibleLoaded = false;
        });
        getXmlDoc();
      }
    }
  }

  void _previous() {
    if (widget.chapter > 0) {
      setState(() {
        widget.chapter -= 1;
        _bibleLoaded = false;
      });
      getXmlDoc();
    } else if (widget.testament == 0) {
      if (widget.book != 0) {
        setState(() {
          widget.chapter = _bibleStructure[widget.testament]
                  .values
                  .elementAt(widget.book - 1) -
              1;
          widget.book -= 1;
          _bibleLoaded = false;
        });
        getXmlDoc();
      }
    } else if (widget.testament == 1) {
      if (widget.book != 0) {
        setState(() {
          widget.chapter = _bibleStructure[widget.testament]
                  .values
                  .elementAt(widget.book - 1) -
              1;
          widget.book -= 1;
          _bibleLoaded = false;
        });
        getXmlDoc();
      } else {
        setState(() {
          widget.testament = 0;
          widget.book = 38;
          widget.chapter = 3;
        });
        getXmlDoc();
      }
    }
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
            IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  _previous();
                }),
            Text(
              '${_bibleStructure[widget.testament].keys.elementAt(widget.book)} - ${widget.chapter + 1}',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                ),
                onPressed: () {
                  _next();
                }),
          ],
        ),
      ),
      body: _bibleLoaded
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _getBibleVersions(),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      for (String verse in verses)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Note(
                                  passage:
                                      '${_bibleStructure[widget.testament].keys.elementAt(widget.book)} ${widget.chapter + 1}:${verses.indexOf(verse) + 1}',
                                  verse: verse,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1,
                                  color: Color(
                                    0XFF595959,
                                  ),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RichText(
                                text: TextSpan(
                                  text: '${verses.indexOf(verse) + 1}. ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.pink,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '$verse',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 45,
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
