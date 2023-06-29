import 'package:proyecto_test_flutter_1/Data/person_model.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

import 'data_source.dart';

class SQLdataSource implements DataSource {
  Future<sql.Database> _getDB() async {
    String dbPath = join(await sql.getDatabasesPath(), 'personas.db');
    return sql.openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDB,
      onOpen: (db) async {
        await db.execute("PRAGMA foreign_keys = ON;");
      },
    );
  }

  Future<void> _createDB(db, version) async {
    await db.execute('''CREATE TABLE personas(
        usuario TEXT PRIMARY KEY,
        email TEXT,
        sobreMi TEXT, 
        avatarIndex INTEGER
      )''');
    await db.execute('''CREATE TABLE relaciones(
        persona1 TEXT REFERENCES personas(usuario) ON DELETE CASCADE,
        persona2 TEXT REFERENCES personas(usuario) ON DELETE CASCADE,
        PRIMARY KEY(persona1, persona2),
        CHECK (persona1 != persona2)
      )''');
  }

  @override
  addPerson(Persona persona) async {
    sql.Database db = await _getDB();
    int result = await db.insert('personas', persona.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.ignore);
    if (result != 0) {
      for (String usuario in persona.relaciones) {
        await db.insert(
            'relaciones', {'persona1': persona.usuario, 'persona2': usuario},
            conflictAlgorithm: sql.ConflictAlgorithm.ignore);
      }
    }
  }

  @override
  deletePerson(Persona persona) async {
    sql.Database db = await _getDB();

    db.delete('personas', where: 'usuario = ?', whereArgs: [persona.usuario]);
  }

  @override
  editPerson(Persona persona) async {
    sql.Database db = await _getDB();

    int result = await db.update('personas', persona.toMap(),
        where: 'usuario = ?',
        whereArgs: [persona.usuario],
        conflictAlgorithm: sql.ConflictAlgorithm.ignore);

    if (result != 0) {
      await db.delete('relaciones',
          where: '(persona1 = ? OR persona2 = ?)',
          whereArgs: [
            persona.usuario,
            persona.usuario,
          ]);
      for (String id in persona.relaciones) {
        await db.insert(
            'relaciones', {'persona1': persona.usuario, 'persona2': id},
            conflictAlgorithm: sql.ConflictAlgorithm.ignore);
      }
    }
  }

  @override
  retrievePerson(String usuario) async {
    sql.Database db = await _getDB();

    final personasQueryResult =
        await db.query('personas', where: 'usuario = ?', whereArgs: [usuario]);

    if (personasQueryResult.isEmpty) {
      return null;
    }

    final personaJSON = personasQueryResult[0];

    final relacionesQueryResult = await db.query('relaciones',
        where: 'persona1 = ? OR persona2 = ?', whereArgs: [usuario, usuario]);
    return Persona.fromJSON(
        personaJSON, relacionesToList(relacionesQueryResult, usuario));
  }

  @override
  clearDataSource() async {
    sql.Database db = await _getDB();

    db.delete('personas');
  }

  @override
  retrieveAll() async {
    sql.Database db = await _getDB();

    final personasQueryResult = await db.query('personas');
    final relacionesQueryResult = await db.query('relaciones');

    List<Persona> personas = [];

    for (final personaJSON in personasQueryResult) {
      String usuario = personaJSON['usuario'] as String;
      personas.add(Persona.fromJSON(
          personaJSON, relacionesToList(relacionesQueryResult, usuario)));
    }

    return personas;
  }

  List<String> relacionesToList(
      List<Map<String, Object?>> relacionesQueryResult, String usuario) {
    List<String> relaciones = [];
    for (final relacionJSON in relacionesQueryResult) {
      if (relacionJSON['persona1'] == usuario &&
          !relaciones.contains(relacionJSON['persona2'])) {
        relaciones.add(relacionJSON['persona2'] as String);
      } else if (relacionJSON['persona2'] == usuario &&
          !relaciones.contains(relacionJSON['persona1'])) {
        relaciones.add(relacionJSON['persona1'] as String);
      }
    }
    return relaciones;
  }
}
