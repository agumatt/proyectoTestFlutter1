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
    );
  }

  Future<void> _createDB(db, version) async {
    await db.execute('''CREATE TABLE personas(
        id TEXT PRIMARY KEY,
        nombres TEXT,
        apellidos TEXT,
        email TEXT,
        sobreMi TEXT, 
        UNIQUE (nombres, apellidos)

      )''');
    await db.execute('''CREATE TABLE relaciones(
        persona1 TEXT,
        persona2 TEXT,
        PRIMARY KEY(persona1, persona2),
        FOREIGN KEY (persona1) REFERENCES personas(id) ON DELETE CASCADE,
        FOREIGN KEY (persona2) REFERENCES personas(id) ON DELETE CASCADE,
        CHECK (persona1 != persona2)
      )''');
  }

  @override
  addPerson(Persona persona) async {
    sql.Database db = await _getDB();
    await db.insert('personas', persona.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.ignore);
    for (String id in persona.relaciones) {
      await db.insert('relaciones', {'persona1': persona.id, 'persona2': id},
          conflictAlgorithm: sql.ConflictAlgorithm.ignore);
    }
  }

  @override
  deletePerson(Persona persona) async {
    sql.Database db = await _getDB();

    db.delete('personas', where: 'id = ?', whereArgs: [persona.id]);
  }

  @override
  editPerson(Persona persona) async {
    sql.Database db = await _getDB();

    await db.update('persona', persona.toMap(),
        where: 'id = ?',
        whereArgs: [persona.id],
        conflictAlgorithm: sql.ConflictAlgorithm.ignore);

    await db.delete('relaciones',
        where:
            '(persona1 = ? AND persona2 NOT IN ?) OR (persona2 = ? AND persona1 NOT IN ?)',
        whereArgs: [
          persona.id,
          persona.relaciones,
          persona.id,
          persona.relaciones
        ]);
    for (String id in persona.relaciones) {
      await db.insert('relaciones', {'persona1': persona.id, 'persona2': id},
          conflictAlgorithm: sql.ConflictAlgorithm.ignore);
    }
  }

  @override
  retrievePerson(String nombres, String apellidos) async {
    sql.Database db = await _getDB();

    final personasQueryResult = await db.query('personas',
        where: 'nombres = ? AND apellidos = ?',
        whereArgs: [nombres, apellidos]);

    if (personasQueryResult.isEmpty) {
      return null;
    }

    Map<String, String> personaJSON =
        personasQueryResult[0] as Map<String, String>;

    String personaID = personaJSON['id'] as String;

    final relacionesQueryResult = await db.query('relaciones',
        where: 'persona1 = ? OR persona2 = ?',
        whereArgs: [personaID, personaID]);

    List<String> relaciones = [];
    for (final relacionJSON in relacionesQueryResult) {
      if (relacionJSON['persona1'] != personaID &&
          !relaciones.contains(relacionJSON['persona1'])) {
        relaciones.add(relacionJSON['persona1'] as String);
      } else if (relacionJSON['persona2'] != personaID &&
          !relaciones.contains(relacionJSON['persona2'])) {
        relaciones.add(relacionJSON['persona2'] as String);
      }
    }
    return Persona.fromJSON(personaJSON, relaciones);
  }

  @override
  Future<void> clearDataSource() async {
    sql.Database db = await _getDB();

    db.delete('personas');
  }
}
