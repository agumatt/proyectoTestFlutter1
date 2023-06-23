import 'package:proyecto_test_flutter_1/Data/person_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

import 'data_source.dart';

class SQLdataSource implements DataSource {
  Future<sql.Database> _getDB() async {
    return await sql.openDatabase(
      'personas.db',
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(db, version) async {
    await db.execute('''CREATE TABLE personas(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
        nombres TEXT,
        apellidos TEXT,
        email TEXT,
        sobreMi TEXT, 
        CONSTRAINT UNIQUE (nombres, apellidos)

      )''');
    await db.execute('''CREATE TABLE relaciones(
        persona1 FOREIGN KEY REFERENCES personas(id) ON DELETE CASCADE
        persona2 FOREIGN KEY REFERENCES personas(id) ON DELETE CASCADE
        CONSTRAINT UNIQUE (persona1, persona2)
      )''');
  }

  @override
  addPerson(Person person) async {
    sql.Database db = await _getDB();
    // TODO: implement addPerson
    throw UnimplementedError();
  }

  @override
  deletePerson(String nombres, String apellidos) async {
    sql.Database db = await _getDB();

    // TODO: implement deletePerson
    throw UnimplementedError();
  }

  @override
  editPerson(Person person) async {
    sql.Database db = await _getDB();
    // TODO: implement editPerson
    throw UnimplementedError();
  }

  @override
  retrievePerson(String nombres, String apellidos) async {
    sql.Database db = await _getDB();
    // TODO: implement retrievePerson
    throw UnimplementedError();
  }
}
