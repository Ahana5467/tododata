
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class CategoryController {
  static late Database todoDatabase;
  static late Database categoryDatabase;
  static List<Map> todoList = [];
  static List<Map> categoryList = [];

  static Future<void> initializeDataBase() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb; 
    }

    // Open 'todo.db' for Todo table
    todoDatabase = await openDatabase(
      "todo.db",
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE Todo (id INTEGER PRIMARY KEY, title TEXT, description TEXT, date TEXT, category TEXT, isChecked INTEGER)',
        );
      },
    );

    // Open 'category.db' for Category table
    categoryDatabase = await openDatabase(
      "category.db",
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE Category (id INTEGER PRIMARY KEY, title TEXT, description TEXT)',
        );
      },
    );
  }

  // Add Todo function
  static Future<void> addtodo({
    required String title,
    required String description,
    required String date,
    required String category,
    bool isChecked = false,
  }) async {
    await todoDatabase.rawInsert(
      'INSERT INTO Todo(title, description, date, category, isChecked) VALUES(?, ?, ?, ?, ?)',
      [title, description, date, category, isChecked ? 1 : 0],
    );
    await gettodo(); 
  }

  // Add Category function
  static Future<void> addcategory({
    required String title,
    required String description,
  }) async {
    await categoryDatabase.rawInsert(
      'INSERT INTO Category(title, description) VALUES(?, ?)',
      [title, description],
    );
    await getcategory();
  }

// update todo function
static Future<void> updatetodo({
  required int id,
  required String title,
  required String description,
  required String date,
  required String category,
  required bool isChecked,
}) async {
  await todoDatabase.rawUpdate(
    'UPDATE Todo SET title = ?, description = ?, date = ?, category = ?, isChecked = ? WHERE id = ?',
    [title, description, date, category, isChecked ? 1 : 0, id],
  );
  await gettodo();
}



// Delete todo list

  static Future<void> deletetodo(int id) async {
    await todoDatabase
    .rawDelete('DELETE FROM Todo WHERE id = ?', [id]);
    await gettodo();
  }


// delete category list

  static Future<void> deletecategory(int id) async {
    await categoryDatabase
    .rawDelete('DELETE FROM Category WHERE id = ?', [id]);
    await getcategory();
  }



  // Get Todo list
  static Future<void> gettodo() async {
    todoList = await todoDatabase.rawQuery('SELECT * FROM Todo');
  }

  // Get Category list
  static Future<void> getcategory() async {
    categoryList = await categoryDatabase.rawQuery('SELECT * FROM Category');
  }


 

}











