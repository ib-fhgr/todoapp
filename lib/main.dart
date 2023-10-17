import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/database.dart';
import 'todo_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // hier startet unsere App
  // Wir stellen den Datenbank-Zugriff mit "Provider" bereit
  runApp(ChangeNotifierProvider(
    create: (context) => TodoDatabase(),
    child: const MyApp(),
  ));
}

// Das Haupt-Widget unserer App - macht aber nicht viel:
// hier wird das MaterialApp-Widget angelegt, man könnte hier
// Farben und Designangaben ändern. Die eigentlich Liste ist
// dann in einer anderen Datei als eigenen Widget implementiert.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: const TodoList(),
    );
  }
}
