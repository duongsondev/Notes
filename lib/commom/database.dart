import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseApp {
  // table title
  final String tblCategory = "Category";
  final String tblNotes = "Notes";

  static Future<Database> getDatabaseApp() async {
    return openDatabase(join(await getDatabasesPath(), "notes.db"),
        onCreate: (db, version) async {
          await db.execute("CREATE TABLE $tblCategory("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "title TEXT,"
              "color INTEGER)");
          await db.execute("CREATE TABLE $tblNotes("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "title TEXT,"
              "content TEXT,"
              "create TEXT,"
              "lastUpdated TEXT,"
              "active INTEGER,"
              "category INTEGER)");
          await db.insert(tblCategory, {
            'id': 0,
            'name': 'All',
            'color': Colors.orange.value
          });
        }, version: 1);
  }
}
