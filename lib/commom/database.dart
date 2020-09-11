import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
class DatabaseApp{
  static Future<Database> getDatabaseApp() async{
    return openDatabase(join(await getDatabasesPath(), "notes.db"),onCreate: (db, version){
      db.execute("");
    },version: 1);
  }
}