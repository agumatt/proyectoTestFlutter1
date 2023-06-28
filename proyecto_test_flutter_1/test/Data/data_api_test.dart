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

  Persona persona1 = Persona(
      nombres: 'Maria Juana',
      apellidos: 'Fuentes Silva',
      email: 'hola@hola.cl');

  Persona persona2 = Persona(
      nombres: 'Pedro', apellidos: 'Fuentes Silva', email: 'pescao@hola.cl');

  Persona persona3 = Persona(
      nombres: 'Darío Renato',
      apellidos: 'Estévez Vivanco',
      email: 'chao@hola.cl');

  setUp(() async {
    return dataSource.clearDataSource();
  });

  test('agregar persona', () async {
    await dataSource.addPerson(persona1);
    Persona? p1 =
        await dataSource.retrievePerson(persona1.nombres, persona1.apellidos);
    expect(p1, persona1);
  });

  test('eliminar persona', () async {
    await dataSource.addPerson(persona1);
    await dataSource.deletePerson(persona1);
    Persona? p1 =
        await dataSource.retrievePerson(persona1.nombres, persona1.apellidos);
    expect(p1, null);
  });

  test('editar persona', () async {
    await dataSource.addPerson(persona1);
    Persona persona1Edit = persona1.copyWith(
        nombres: 'Nombre editado',
        apellidos: 'apellido editado',
        sobreMi: 'jejejej');
    await dataSource.editPerson(persona1Edit);
    Persona? p1 = await dataSource.retrievePersonById(persona1.id);
    expect(p1, persona1Edit);
  });

  test('relaciones', () async {
    await dataSource.addPerson(persona1);
    await dataSource.addPerson(persona2);
    await dataSource.addPerson(persona3);

    Persona persona1Edit =
        persona1.copyWith(relaciones: [persona2.id, persona3.id]);
    await dataSource.editPerson(persona1Edit);

    Persona? p1 = await dataSource.retrievePersonById(persona1.id);
    Persona? p2 = await dataSource.retrievePersonById(persona2.id);
    Persona? p3 = await dataSource.retrievePersonById(persona3.id);

    assert(p1!.relaciones.contains(persona2.id));
    assert(p1!.relaciones.contains(persona3.id));
    assert(p2!.relaciones.contains(persona1.id));
    assert(p3!.relaciones.contains(persona1.id));

    await dataSource.deletePerson(persona2);
    p1 = await dataSource.retrievePersonById(persona1.id);
    assert(p1!.relaciones.length == 1);
    assert(!(p1!.relaciones.contains(persona2.id)));
    assert(p1!.relaciones.contains(persona3.id));
  });
}
