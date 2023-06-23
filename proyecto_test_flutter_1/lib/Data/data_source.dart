import 'package:proyecto_test_flutter_1/Data/person_model.dart';

abstract class DataSource {
  Future<void> addPerson(Person person);
  Future<void> editPerson(Person person);
  Future<void> deletePerson(String nombres, String apellidos);
  Future<Person> retrievePerson(String nombres, String apellidos);
}
