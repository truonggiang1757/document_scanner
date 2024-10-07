import 'package:document_scanner/JSON/users.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  final databaseName = "auth.db";

  String user = ''' 
  CREATE TABLE users (
  userId INTERGER PRIMARY KEY AUTOINCREMENT,
  fullname TEXT,
  email TEXT,
  username TEXT UNIQUE,
  password TEXT
  )
   ''';

  Future<Database> initDB() async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db,version) async{
      await db.execute(user);
    });
  }


  Future<bool> authenticate(Users usr) async{
    final Database db = await initDB();
     var result = await db.rawQuery("select * from users where username = '${usr.username}' AND password = '${usr.password}'");
    if(result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> createUser(Users usr) async{
    final Database db = await initDB();
    return db.insert("users", usr.toMap());
  }

  Future<Users?> getUser(String userName) async{
    final Database db = await initDB();
    var res = await db.query("users", where: "username = ?", whereArgs: [userName]);
    return res.isNotEmpty ? Users.fromMap(res.first): null;
  }
}