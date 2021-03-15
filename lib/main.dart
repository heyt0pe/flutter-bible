import 'package:bible/reading.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _bibleVersion = 'ESV';

  List versions = ['ESV', 'KJV', 'NIV', 'NLT'];

  // int count = 0;
  // print(document
  //     .findAllElements('testament')
  //     .elementAt(1)
  //     .findAllElements('book')
  //     .elementAt(3)
  //     .findAllElements('chapter')
  //     .elementAt(10)
  //     .findAllElements('verse')
  //     .map((verse) {
  //   count += 1;
  //   print('$count. ${verse.text}');
  //   print('');
  // }));

  void initState() {
    super.initState();
    _bibleVersion = versions.first;
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
              groupValue: _bibleVersion,
              onChanged: (value) {
                setState(() {
                  _bibleVersion = value;
                });
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

  List<Widget> _showBibleStructure() {
    List<Widget> bibleStructure = [];
    int test = 0;
    bibleStructure.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 0, 25),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Text(
            'Old Testament',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
    for (Map testament in _bibleStructure.values) {
      int bk = 0;
      for (String book in testament.keys) {
        bibleStructure.add(
          Container(
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
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showVersesFor = _showVersesFor == book ? '' : book;
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(book),
                          _showVersesFor == book
                              ? Icon(
                                  Icons.keyboard_arrow_up,
                                )
                              : Icon(
                                  Icons.keyboard_arrow_down,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                _showVersesFor == book
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            for (int i = 0; i < testament[book]; i++)
                              VerseButton(
                                testament: test,
                                book: bk,
                                chapter: i,
                                version: _bibleVersion,
                              ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        );
        bk += 1;
      }
      test += 1;
      if (test == 1) {
        bibleStructure.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 25),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                'New Testament',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }
    }
    return bibleStructure;
  }

  String _showVersesFor = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
              children: _showBibleStructure(),
            ),
            SizedBox(
              height: 55,
            ),
          ],
        ),
      ),
    );
  }
}

class VerseButton extends StatelessWidget {
  VerseButton({
    @required this.testament,
    @required this.book,
    @required this.chapter,
    @required this.version,
  });

  final int testament;
  final int book;
  final int chapter;
  final String version;

  void showChapter(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BibleReading(
          testament: testament,
          book: book,
          chapter: chapter,
          version: version,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showChapter(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.pink,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text('${chapter + 1}'),
          ),
        ),
      ),
    );
  }
}
