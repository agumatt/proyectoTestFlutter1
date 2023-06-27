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

  test('agregar persona', () {});
}
