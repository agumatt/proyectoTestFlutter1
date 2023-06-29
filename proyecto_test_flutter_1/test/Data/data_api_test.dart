import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_test_flutter_1/Data/person_model.dart';
import 'package:proyecto_test_flutter_1/Data/sql_data_source.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;

  SQLdataSource dataSource = SQLdataSource();

  Persona persona1 = Persona(usuario: 'Maria Juana', email: 'hola@hola.cl');

  Persona persona2 = Persona(usuario: 'Pedro', email: 'pescao@hola.cl');

  Persona persona3 = Persona(usuario: 'Darío Renato', email: 'chao@hola.cl');

  setUp(() async {
    return dataSource.clearDataSource();
  });

  test('agregar persona', () async {
    await dataSource.addPerson(persona1);
    Persona? p1 = await dataSource.retrievePerson(persona1.usuario);
    expect(p1, persona1);
  });

  test('eliminar persona', () async {
    await dataSource.addPerson(persona1);
    await dataSource.deletePerson(persona1);
    Persona? p1 = await dataSource.retrievePerson(persona1.usuario);
    expect(p1, null);
  });

  test('editar persona', () async {
    await dataSource.addPerson(persona1);
    Persona persona1Edit = persona1.copyWith(sobreMi: 'jejejej');
    await dataSource.editPerson(persona1Edit);
    Persona? p1 = await dataSource.retrievePerson(persona1.usuario);
    expect(p1, persona1Edit);
  });

  test('relaciones', () async {
    await dataSource.addPerson(persona1);
    await dataSource.addPerson(persona2);
    await dataSource.addPerson(persona3);

    Persona persona1Edit =
        persona1.copyWith(relaciones: [persona2.usuario, persona3.usuario]);
    await dataSource.editPerson(persona1Edit);

    Persona? p1 = await dataSource.retrievePerson(persona1.usuario);
    Persona? p2 = await dataSource.retrievePerson(persona2.usuario);
    Persona? p3 = await dataSource.retrievePerson(persona3.usuario);

    assert(p1!.relaciones.contains(persona2.usuario));
    assert(p1!.relaciones.contains(persona3.usuario));
    assert(p2!.relaciones.contains(persona1.usuario));
    assert(p3!.relaciones.contains(persona1.usuario));

    await dataSource.deletePerson(persona2);
    p1 = await dataSource.retrievePerson(persona1.usuario);
    assert(p1!.relaciones.length == 1);
    assert(!(p1!.relaciones.contains(persona2.usuario)));
    assert(p1!.relaciones.contains(persona3.usuario));
  });
}
