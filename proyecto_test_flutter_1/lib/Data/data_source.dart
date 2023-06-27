import 'package:proyecto_test_flutter_1/Data/person_model.dart';

abstract class DataSource {
  Future<void> addPerson(Persona persona);
  Future<void> editPerson(Persona persona);
  Future<void> deletePerson(Persona persona);
  Future<Persona?> retrievePerson(String nombres, String apellidos);
  Future<void> clearDataSource();
}
