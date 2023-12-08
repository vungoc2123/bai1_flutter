
import 'package:bai_1/Person.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonListNotifier extends StateNotifier<List<Person>> {
  PersonListNotifier() : super([]);

  void addPerson(Person person) {
    state = [...state, person];
  }

  void updatePerson(int index, Person person) {
    final updatedPersons = List<Person>.from(state);
    updatedPersons[index] = Person(name: person.name, age: person.age);
    state = updatedPersons;
  }

  void removePerson(int index) {
    final updatedPersons = List<Person>.from(state);
    updatedPersons.removeAt(index);
    state = updatedPersons;
  }
}
