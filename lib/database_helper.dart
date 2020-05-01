import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "movie_database";
  static final _databaseVersion = 1;
  static final table = "movies";
  static final columnId = "id";
  static final columnMovieName = "movieName";
  static final columnReleaseData = "releaseDate";
  static final columnPosterImage = "posterImage";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if(_database != null){
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory databaseDirectory = await getApplicationDocumentsDirectory();
    String path = join(databaseDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(''' 
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnMovieName TEXT UNIQUE NOT NULL,
            $columnPosterImage TEXT UNIQUE NOT NULL,
            $columnReleaseData TEXT UNIQUE NOT NULL
          )
          ''');
  }
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String,dynamic>>> getAllMovies() async {
    Database database = await instance.database;
    return await database.query(table);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future delete() async{
    Database database = await instance.database;
    await database.delete(table);
  }

}