import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Person.dart';
import 'PersonListNotifier.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
        debugShowCheckedModeBanner: false);
  }
}

final personListProvider =
StateNotifierProvider<PersonListNotifier, List<Person>>(
      (ref) => PersonListNotifier(),
);

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ItemList Example'),
      ),
      body: Consumer(builder: (context, watch, child) {
        final personList = ref.watch(personListProvider);
        return ListView.builder(
          itemCount: personList.length,
          itemBuilder: (context, index) {
            var person = personList[index];
            return itemPerson(context, ref, person, index);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add onPressed handler for adding new item
          _showMyDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget itemPerson(BuildContext context, WidgetRef ref, Person person, int index) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      children: [
        Expanded(child: Text(person.name!)),
        Expanded(child: Text(person.age!.toString())),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            _showMyDialog(context, ref, person, index);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            ref.read(personListProvider.notifier).removePerson(index);
          },
        ),
      ],
    ),
  );
}

Future<void> _showMyDialog(BuildContext context, WidgetRef ref, [Person? person, int? index]) async {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  nameController.text = person?.name ?? '';
  ageController.text = person?.age?.toString() ?? '';
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add person'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Age',
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(10.0), // Adjust the value as needed
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              person != null
                  ? ref.read(personListProvider.notifier)
                    .updatePerson(index!, Person(name: nameController.text,
                  age: int.parse(ageController.text)))
                  : ref.read(personListProvider.notifier)
                    .addPerson(Person(name: nameController.text,
                  age: int.parse(ageController.text)));
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}
