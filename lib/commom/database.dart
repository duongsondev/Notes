import 'package:fa_notes/model/notes.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseApp {
  // table title
  static final String tblNotes = "Notes";

  static Future<Database> getDatabaseApp() async {
    return openDatabase(join(await getDatabasesPath(), "notes.db"), onCreate: (db, version) async {
      await db.execute("CREATE TABLE $tblNotes("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "title TEXT,"
          "content TEXT,"
          "type INTEGER,"
          "dateCreated TEXT,"
          "lastUpdated TEXT,"
          "active INTEGER)");
    }, version: 1);
  }

  static Future<List<Notes>> getListNotes(int active) async {
    final Database db = await getDatabaseApp();
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM $tblNotes WHERE active == $active");
    return List.generate(
        maps.length,
        (i) => Notes(maps[i]['id'], maps[i]['title'], maps[i]['content'], maps[i]['type'],
            DateTime.parse(maps[i]['dateCreated']), DateTime.parse(maps[i]['lastUpdated']), maps[i]['active']));
  }

  static Future<List<Notes>> getListNotesByType(int type) async {
    final Database db = await getDatabaseApp();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM $tblNotes WHERE active == 1 AND type == $type");
    return List.generate(
        maps.length,
        (i) => Notes(maps[i]['id'], maps[i]['title'], maps[i]['content'], maps[i]['type'],
            DateTime.parse(maps[i]['dateCreated']), DateTime.parse(maps[i]['lastUpdated']), maps[i]['active']));
  }

  static Future<bool> insertNotes(Notes notes) async {
    try {
      final Database db = await getDatabaseApp();
      await db.insert(tblNotes, notes.toMap());
      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  static Future<bool> updateNotes(Notes notes) async {
    try {
      final Database db = await getDatabaseApp();
      await db.update(tblNotes, notes.toMap(), where: "id == ${notes.id}");
      return true;
    } catch (ex) {
      return false;
    }
  }

  static Future<bool> deleteNotes(int id) async {
    try {
      final Database db = await getDatabaseApp();
      await db.delete(tblNotes, where: "id == $id");
      return true;
    } catch (ex) {
      return false;
    }
  }

  static Future<bool> setActive(int id, int active) async {
    try {
      final Database db = await getDatabaseApp();
      await db.update(tblNotes, {'active': active}, where: "id == $id");
      return true;
    } catch (ex) {
      return false;
    }
  }
}
