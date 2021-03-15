import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabaseService {
  String path;

  NotesDatabaseService._();

  static final NotesDatabaseService db = NotesDatabaseService._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await init();
    return _database;
  }

  init() async {
    String path = await getDatabasesPath();
    path = join(path, 'notes.db');
    print("Entered path $path");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE Notes (_id INTEGER PRIMARY KEY, passage TEXT, verse TEXT, content TEXT);',
      );
      print('New table created at $path');
    });
  }

  Future<List> getNotesFromDB() async {
    final db = await database;
    List notesList = [];
    List<Map> maps = await db.query('Notes', columns: [
      '_id',
      'passage',
      'verse',
      'content',
    ]);
    if (maps.length > 0) {
      maps.forEach((map) {
        notesList.add(map);
      });
    }
    return notesList;
  }

  Future<List<Map>> getNoteFromDB(String passage) async {
    final db = await database;
    List<Map> map =
        await db.rawQuery('SELECT * FROM Notes WHERE passage = ?', [passage]);
    return map;
  }

  updateNoteInDB(Map updatedNote) async {
    final db = await database;
    await db.update('Notes', updatedNote,
        where: 'passage = ?', whereArgs: [updatedNote['passage']]);
    print('Note updated: ${updatedNote['passage']} ${updatedNote['content']}');
  }

  deleteNoteInDB(Map noteToDelete) async {
    final db = await database;
    await db
        .delete('Notes', where: '_id = ?', whereArgs: [noteToDelete['_id']]);
    print('Note deleted');
  }

  Future addNoteInDB(Map newNote) async {
    final db = await database;
    await db.transaction((transaction) {
      transaction.rawInsert(
          'INSERT into Notes(passage, verse, content) VALUES ("${newNote['passage']}", "${newNote['verse']}", "${newNote['content']}");');
    });
    print('Note added: ${newNote['passage']} ${newNote['content']}');
    return newNote;
  }
}
