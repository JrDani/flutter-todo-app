import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/model/todo.dart';  

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  String tblTodo = "todo";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colPriority = "priority";
  String colDate = "date";

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database _database;
  Future<Database> get database async {
    if(_database == null) {
      _database = await initializeDb();
    }
    return _database;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path  = dir.path + "todos.db";
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTodos;
  }

  void _createDb(Database database, int newVersion) async {
    await database.execute(
       "CREATE TABLE $tblTodo($colId INTEGER PRIMARY KEY, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)");
  }

  Future<int> insertTodo(Todo todo) async{
    Database db = await this.database;
    var result = await db.insert(tblTodo, todo.toMap());
    return result;
  }

  Future<List> getTodos() async {
    Database db = await this.database;
    var result = await db.rawQuery("select * from $tblTodo order by $colPriority ASC");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    var result = Sqflite.firstIntValue(
      await db.rawQuery("select count(*) from $tblTodo")
    );
    return result;
  }

  Future<int> updateTodo(Todo todo) async {
    var db = await this.database;
    var result = await db.update(tblTodo, todo.toMap(), where: "$colId = ?", 
      whereArgs: [todo.id]);
    return result;
  }

  Future<int> deleteTodo(int id) async {
    int result;
    var db = await this.database;
    result = await db.rawDelete("delete from $tblTodo where $colId = $id");
    return result;
  }
}
